;Copyright (C) 2004-2012 John T. Haller of PortableApps.com

;Website: http://portableapps.com/JooleemPortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define PORTABLEAPPNAME "Jooleem Portable"
!define APPNAME "Jooleem"
!define NAME "JooleemPortable"
!define VER "1.6.1.0"
!define WEBSITE "PortableApps.com/JooleemPortable"
!define DEFAULTEXE "Jooleem.exe"
!define DEFAULTAPPDIR "Jooleem"
!define DEFAULTSETTINGSPATH "settings"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

!include FileFunc.nsh
!insertmacro GetParent
!include ReadINIStrWithDefault.nsh
!include CheckForPlatformSplashDisable.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var EXECSTRING
Var DISABLESPLASHSCREEN
Var MISSINGFILEORPATH


Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckINI
		Abort

	CheckINI:
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		ClearErrors

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" FoundProgramEXE

	;NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" CreateExecString
			;=== Show the splash screen while processing registry entries
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg
	
	CreateExecString:
		StrCpy $EXECSTRING `"$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}"`
	
	;SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$EXEDIR\Data\settings\*.*" MoveSettings
			CreateDirectory "$EXEDIR\Data\settings"
			CreateDirectory "$EXEDIR\Data\screenshots"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\highscores.dat" "$EXEDIR\Data\settings"
	
	MoveSettings:
		Rename "$EXEDIR\Data\settings\highscores.dat" "$EXEDIR\App\${DEFAULTAPPDIR}\highscores.dat"
		Rename "$EXEDIR\Data\screenshots" "$EXEDIR\App\${DEFAULTAPPDIR}\data\screenshots"

	;LaunchNow:
		SetOutPath "$EXEDIR\App\${DEFAULTAPPDIR}"
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning

	;=== Put the settings file back
	Sleep 500
	Rename "$EXEDIR\App\${DEFAULTAPPDIR}\highscores.dat" "$EXEDIR\Data\settings\highscores.dat"
	Rename "$EXEDIR\App\${DEFAULTAPPDIR}\data\screenshots" "$EXEDIR\Data\screenshots"
	newadvsplash::stop /WAIT
SectionEnd