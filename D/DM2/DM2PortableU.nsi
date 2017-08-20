;Copyright 2004-2010 John T. Haller
;Copyright 2008-2010 Vic Saville

;Website: http://portableapps.com/apps/utilities/dm2_portable

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

!define PORTABLEAPPNAME "DM2 Portable"
!define APPNAME "DM2"
!define NAME "DM2Portable"
!define VER "1.6.9.0"
!define WEBSITE "portableapps.com/apps/utilities/dm2_portable"
!define DEFAULTEXE "DM2.exe"
!define DEFAULTAPPDIR "DM2"
!define DEFAULTSETTINGSDIR "settings"
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
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters
!include LogicLib.nsh

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include ReadINIStrWithDefault.nsh
!include ReplaceInFileWithTextReplace.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var DISABLESPLASHSCREEN
Var SECONDARYLAUNCH
Var MISSINGFILEORPATH
Var LASTDRIVE
Var CURRENTDRIVE
Var APPLANGUAGE

Section "Main"
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy $INIPATH "$EXEDIR"

		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $DISABLESPLASHSCREEN "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Goto TheEnd

	FoundProgramEXE:
		;=== Check if launcher is already running
		System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
		Pop $0
		StrCmp $0 0 CheckAppRunning
			StrCpy $SECONDARYLAUNCH "true"
			FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
			StrCmp $R0 "1" GetPassedParameters
			MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION "Another instance of ${PORTABLEAPPNAME} is still closing. Please click OK and launch ${PORTABLEAPPNAME} again."
			Goto TheEnd

	CheckAppRunning:
		;=== Check if (local) app is running
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance
		;=== Check if app is running
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

	WarnAnotherInstance:
		MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Goto TheEnd

	DisplaySplash:
		StrCmp $DISABLESPLASHSCREEN "true" CheckSettings
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L "$PLUGINSDIR\splash.jpg"

	CheckSettings:
		;=== Check for data files
		IfFileExists "$SETTINGSDIRECTORY\*.*" GetPassedParameters

			;=== Create the default settings directory
			CreateDirectory "$SETTINGSDIRECTORY"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\*.*" "$SETTINGSDIRECTORY"

			;=== Create the default settings file
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "xx"

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
		StrCmp $ADDITIONALPARAMETERS "" AdjustPaths

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	AdjustPaths:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		ReadINIStr $LASTDRIVE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive"
		${GetRoot} $EXEDIR $CURRENTDRIVE
		StrCmp $LASTDRIVE $CURRENTDRIVE GetMenuLanguage
			${ReplaceInFile} '$SETTINGSDIRECTORY\dm2.ini' '$LASTDRIVE\' '$CURRENTDRIVE\'

	;StoreCurrentDriveLetter:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "$CURRENTDRIVE"

	GetMenuLanguage:
		ReadEnvStr $0 "PortableApps.comLocaleWinName"
			StrCpy $APPLANGUAGE $0 "" 5
			StrCmp $APPLANGUAGE "" MoveSettings ;if not set, move on

	;FixMenuLanguage:
		${IfThen} $APPLANGUAGE == "SIMPCHINESE" ${|} StrCpy $APPLANGUAGE "CHINESE" ${|}
		${IfThen} $APPLANGUAGE == "GREEK" ${|} StrCpy $APPLANGUAGE "HELLENIC(GREEK)" ${|}
		${IfThen} $APPLANGUAGE == "ITALIAN" ${|} StrCpy $APPLANGUAGE "ITALIANO" ${|}
		${IfThen} $APPLANGUAGE == "DUTCH" ${|} StrCpy $APPLANGUAGE "NEDERLANDS" ${|}
		${IfThen} $APPLANGUAGE == "PORTUGUESEBR" ${|} StrCpy $APPLANGUAGE "PORTUGUESE(BRAZIL)" ${|}
		${IfThen} $APPLANGUAGE == "SWEDISH" ${|} StrCpy $APPLANGUAGE "SVENSKA" ${|}
		${IfThen} $APPLANGUAGE == "TRADCHINESE" ${|} StrCpy $APPLANGUAGE "TRADITIONAL CHINESE" ${|}

	;GetAppLanguage:
		ReadINIStr $0 "$SETTINGSDIRECTORY\dm2.ini" "settings" "Language"
			StrCmp "$APPLANGUAGE.lang" $0 MoveSettings ;if the same, move on

	;SetAppLanguage:
		IfFileExists "$PROGRAMDIRECTORY\language\$APPLANGUAGE.lang" "" MoveSettings
		WriteINIStr "$SETTINGSDIRECTORY\dm2.ini" "settings" "Language" "$APPLANGUAGE.lang"

	MoveSettings:
		Rename "$SETTINGSDIRECTORY\dm2.ini" "$PROGRAMDIRECTORY\dm2.ini"

	;LaunchNow:
		Sleep 100
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" CheckRunning

	;MoveSettingsBack:
		;=== Put the settings files back
		Sleep 500
		Rename "$PROGRAMDIRECTORY\dm2.ini" "$SETTINGSDIRECTORY\dm2.ini"
		Goto TheEnd

	LaunchAndExit:
		Exec $EXECSTRING

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd