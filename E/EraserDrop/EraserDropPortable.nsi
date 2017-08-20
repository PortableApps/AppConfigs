;Copyright 2004-2012 John T. Haller
;Copyright 2007-2009 Erik Pilsits

;Website: http://PortableApps.com/EraserDropPortable

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

!define NAME "EraserDropPortable"
!define PORTABLEAPPNAME "EraserDrop Portable"
!define APPNAME "EraserDrop"
!define VER "2.1.1.0"
!define WEBSITE "PortableApps.com/EraserDropPortable"
!define DEFAULTEXE "EraserDrop.exe"
!define DEFAULTAPPDIR "EraserDrop"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com (Erik Pilsits)"
VIAddVersionKey LegalCopyright "PortableApps.com and Contributors"
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

;=== Includes
!include FileFunc.nsh
!insertmacro GetParameters
;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var SECONDINSTANCE
Var DISABLESPLASHSCREEN

Section "Main"
	${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
	
	;=== Set Vars
	StrCpy $SECONDINSTANCE "false"
	;=== Set directories
	StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
	StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${APPNAME}"
	
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 ShowSplash
		StrCpy $SECONDINSTANCE "true"
		${GetParameters} $R0
		Goto LaunchNow

	ShowSplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
		;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L "$PLUGINSDIR\splash.jpg"

	SkipSplashScreen:
		;=== Check for data files
		IfFileExists "$PROGRAMDIRECTORY\config.ini" LaunchNow
		IfFileExists "$SETTINGSDIRECTORY\*.*" MoveSettings
			CreateDirectory "$SETTINGSDIRECTORY"

	MoveSettings:
		IfFileExists "$SETTINGSDIRECTORY\config.ini" 0 CopyDefaultSettings
		CopyFiles /SILENT "$SETTINGSDIRECTORY\config.ini" "$PROGRAMDIRECTORY"
			Goto LaunchNow
	
	CopyDefaultSettings:
		IfFileExists "$EXEDIR\App\DefaultData\settings\config.ini" 0 DefaultSettingsError
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\config.ini" "$PROGRAMDIRECTORY"
			Goto LaunchNow
	
	DefaultSettingsError:
		MessageBox MB_OK|MB_ICONSTOP|MB_TOPMOST "Default settings files not found.  Check your installation."
			Abort
	
	LaunchNow:
		SetOutPath "$PROGRAMDIRECTORY"
		StrCmp $SECONDINSTANCE "false" +3
		Exec '"$PROGRAMDIRECTORY\${DEFAULTEXE}" $R0'
		Goto TheEnd
		ExecWait '"$PROGRAMDIRECTORY\${DEFAULTEXE}"'
		
		;=== Move settings back
		Delete "$SETTINGSDIRECTORY\config.ini"
		Rename "$PROGRAMDIRECTORY\config.ini" "$SETTINGSDIRECTORY\config.ini"
	
	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd