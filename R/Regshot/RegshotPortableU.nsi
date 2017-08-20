;Copyright (C) 2004-2012 John T. Haller of PortableApps.com
;Copyright (C) 2007-2008 Patrick Patience of PortableApps.com

;Website: http://portableapps.com/RegshotPortable

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

!define PORTABLEAPPNAME "Regshot Portable"
!define APPNAME "Regshot"
!define NAME "RegshotPortable"
!define VER "1.6.0.0"
!define WEBSITE "PortableApps.com/RegshotPortable"
!define DEFAULTEXE "regshot.exe"
!define DEFAULTEXE64 "regshot_x64.exe"
!define DEFAULTAPPDIR "regshot"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "PortableApps.com & Contributors"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck on
WindowIcon off
SilentInstall silent
AutoCloseWindow true
RequestExecutionLevel user
XPStyle on

; Best Compression
SetCompress auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize on

;=== Include
!include LogicLib.nsh
!include TextFunc.nsh
!insertmacro GetParameters
!include x64.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var SECONDARYLAUNCH
Var DISABLESPLASHSCREEN
Var MISSINGFILEORPATH


Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckINI
		StrCpy $SECONDARYLAUNCH "true"

	CheckINI:
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" CheckSubINI
			StrCpy "$INIPATH" "$EXEDIR"
			Goto ReadINI

	CheckSubINI:
		IfFileExists "$EXEDIR\${NAME}\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR\${NAME}"
			Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory"
		StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory"
		StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\$0"
	

		;=== Check that the above required parameters are present
		IfErrors NoINI
		ReadINIStr $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters"
		ReadINIStr $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen"

	;CleanUpAnyErrors:
		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Correct PROGRAMEXECUTABLE if blank
		StrCmp $PROGRAMEXECUTABLE "" "" EndINI
			${If} ${RunningX64}
				StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE64}"
			${Else}
				StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
			${EndIf}
			Goto EndINI

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		${If} ${RunningX64}
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE64}"
		${Else}
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
		${EndIf}

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\$PROGRAMEXECUTABLE" "" NoProgramEXE
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
			GoTo EndINI

	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		;=== Check if running
		StrCmp $SECONDARYLAUNCH "true" GetPassedParameters
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	DisplaySplash:
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			;=== Show the splash screen while processing registry entries
			;InitPluginsDir
			;File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			;newadvsplash::show /NOUNLOAD 1000 100 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" SettingsDirectory

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$SETTINGSDIRECTORY\*.*" CheckForSettings
			CreateDirectory $SETTINGSDIRECTORY
	
	CheckForSettings:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		IfFileExists "$PROGRAMDIRECTORY\regshot.ini" ReconstructLastDir
		IfFileExists "$SETTINGSDIRECTORY\regshot.ini" MoveSettings
		IfFileExists "$EXEDIR\App\DefaultData\regshot.ini" "" LaunchNow
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\regshot.ini" "$PROGRAMDIRECTORY"
			Goto ReconstructLastDir

	MoveSettings:
		Rename "$SETTINGSDIRECTORY\regshot.ini" "$PROGRAMDIRECTORY\regshot.ini"
		
	ReconstructLastDir:
		ReadINIStr $0 "$PROGRAMDIRECTORY\regshot.ini" "Setup" "OutDir"
		StrCpy $1 $EXEDIR 1 ;get current drive letter
		StrCpy $2 $0 "" 1 ;get the last path without the drive letter
		WriteINIStr "$PROGRAMDIRECTORY\regshot.ini" "Setup" "OutDir" "$1$2"

	LaunchNow:
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning

	;=== Put the settings file back
	Sleep 500
	Rename "$PROGRAMDIRECTORY\regshot.ini" "$SETTINGSDIRECTORY\regshot.ini"
	Goto TheEnd
	
	LaunchAndExit:
		Exec $EXECSTRING

	TheEnd:
		;newadvsplash::stop /WAIT
SectionEnd