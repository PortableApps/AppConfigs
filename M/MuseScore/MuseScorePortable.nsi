;Copyright (C) 2004-2017 John T. Haller
;Copyright (C) 2008-2017 Bart.S

;Website: http://portableapps.com/MuseScorePortable

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


!define PORTABLEAPPNAME "MuseScore Portable"
!define APPNAME "MuseScore"
!define NAME "MuseScorePortable"
!define VER "1.6.11.0"
!define WEBSITE "PortableApps.com/MuseScorePortable"
!define DEFAULTEXE "MuseScore.exe"
!define DEFAULTAPPDIR "MuseScore"
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
Unicode true 
ManifestDPIAware true
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow true
RequestExecutionLevel user
XPStyle On

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include WordFunc.nsh
!insertmacro WordReplace
!include FileFunc.nsh
!insertmacro GetRoot
!insertmacro GetParameters
!include Registry.nsh
!include LogicLib.nsh
;(NSIS Plugins)
!include TextReplace.nsh
;(Custom)
!include ReadINIStrWithDefault.nsh
!include ReplaceInFileWithTextReplace.nsh
!include CheckForPlatformSplashDisable.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
;!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;===Variables
Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var SECONDARYLAUNCH
Var DISABLESPLASHSCREEN
Var MISSINGFILEORPATH
Var LASTDIRECTORY
Var APPLANGUAGE
Var EXISTSFILECHOOSER
Var EXISTSCUSTOMCOLORS

Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckForLocalCopy
		StrCpy $SECONDARYLAUNCH "true"
		Goto CheckINI

	CheckForLocalCopy:
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance CheckINI

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort

	CheckINI:
		;=== Read the parameters from the INI file, if there is one
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

		IfFileExists "$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE" FoundProgramEXE

	;NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	FoundProgramEXE:
		;=== Display splash screen
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		${If} $SECONDARYLAUNCH != "true"
		${Andif} $DISABLESPLASHSCREEN != "true"
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L "$PLUGINSDIR\splash.jpg"
		${EndIf}

		;=== Create ExecString
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE" -c "$SETTINGSDIRECTORY"`
		;=== Get any passed parameters
		${GetParameters} $0
		${If} $0 != ""
			StrCpy $EXECSTRING `$EXECSTRING $0`
		${EndIf}
		;=== Additional Parameters
		${If} $ADDITIONALPARAMETERS != ""
			StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
		${EndIf}

	;SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$SETTINGSDIRECTORY\*.*" ChangeTEMP
			CreateDirectory $SETTINGSDIRECTORY
			ClearErrors
			FileOpen $0 "$SETTINGSDIRECTORY\settings_readme.txt" w
			IfErrors ChangeTEMP
			FileWrite $0 "Your ${APPNAME} settings files will go here."
			FileClose $0

	ChangeTEMP:
		;=== Create a subdirectory in TEMP and tell MuseScore that that is TEMP
		StrCpy $0 "$TEMP\${NAME}"
		${IfNot} ${FileExists} "$0" 
			CreateDirectory $0
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$0").n'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$0").n'

	;CheckForQt:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit

		${registry::Read} "HKCU\Software\QtProject\OrganizationDefaults\Qt\" "filedialog" $R0 $R1
		${If} $R1 != ""
			StrCpy $EXISTSFILECHOOSER "true"
		${EndIf}
		${registry::KeyExists} "HKCU\Software\QtProject\OrganizationDefaults\Qt\customColors" $R0
		${If} $R0 = "0"
			StrCpy $EXISTSCUSTOMCOLORS "true"
		${EndIf}

	;SetDefaults:
		${IfNot} ${FileExists} "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" 
			${WordReplace} "$EXEDIR\Data" "\" "/" "+" $0
			CreateDirectory "$SETTINGSDIRECTORY\${APPNAME}"
			;WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "workingDirectory" "$0"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "showSplashScreen" "false"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "checkUpdateStartup" "false"

			ReadEnvStr $1 "PortableApps.comDocuments"
			${If} $1 != ""
			${AndIf} ${FileExists} "$1"
				StrCpy $2 "$1\${APPNAME}2"
			${Else}
				StrCpy $2 "$EXEDIR\Data"
			${EndIf}
			${WordReplace} $2 "\" "/" "+" $3
			;${WordReplace} "$PROGRAMDIRECTORY\sound" "\" "/" "+" $4
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "myScoresPath" "$3/scores"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "myStylesPath" "$3/styles"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "myImagesPath" "$3/images"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "myTemplatesPath" "$3/templates"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "myPluginsPath" "$3/plugins"
			WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "mySoundfontsPath" "$3/soundfonts"
			;WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "sfPath" '"$4;$3/soundfonts"'
			;WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "sfzPath" "$3/sfz"
		${EndIf}
		WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "showSplashScreen" "false"
		WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "checkUpdateStartup" "false"

	;AdjustPaths:
		IfFileExists "$SETTINGSDIRECTORY\${NAME}Settings.ini" "" MuseScoreLanguage
			ReadINIStr $LASTDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory"
			StrCmp $LASTDIRECTORY "$EXEDIR" MuseScoreLanguage
			StrCmp $LASTDIRECTORY "" MuseScoreLanguage
			${GetRoot} $LASTDIRECTORY $0
			${GetRoot} $EXEDIR $1

		${If} ${FileExists} "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" 
			${WordReplace} "$LASTDIRECTORY" "\" "/" "+" $2
			${WordReplace} "$EXEDIR" "\" "/" "+" $3
			${ReplaceInFile} "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "$2" "$3"
			StrCmp $0 $1 MuseScoreLanguage
			${ReplaceInFile} "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "$0/" "$1/"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\session" 
			${ReplaceInFile} "$SETTINGSDIRECTORY\session" "<path>$0/" "<path>$1/"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\plugins.xml" 
			${ReplaceInFile} "$SETTINGSDIRECTORY\plugins.xml" "<path>$0/" "<path>$1/"
		${EndIf}

	MuseScoreLanguage:
		ReadEnvStr $APPLANGUAGE "PortableApps.comLocaleglibc"
		${Select} $APPLANGUAGE
			${Case} ""
				Goto LaunchNow
			${Case} "hi"	;Hindi
				StrCpy $APPLANGUAGE "hi_IN"
			${CaseElse}
				IfFileExists "$PROGRAMDIRECTORY\locale\mscore_$APPLANGUAGE.*" "" LaunchNow
		${EndSelect}
		WriteINIStr "$SETTINGSDIRECTORY\${APPNAME}\${APPNAME}2.ini" "General" "language" "$APPLANGUAGE"

	LaunchNow:
		;SetOutPath "$EXEDIR\Data"
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory" "$EXEDIR"
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" CheckRunning

	;Cleanup:
		RMDir /r "$TEMP\${NAME}"

	;CleanupRegistry:
		${If} $EXISTSFILECHOOSER != "true"
			${registry::DeleteValue} "HKCU\Software\QtProject\OrganizationDefaults\Qt\" "filedialog" $R0
		${EndIf}
		${If} $EXISTSCUSTOMCOLORS != "true"
			${registry::DeleteKey} "HKCU\Software\QtProject\OrganizationDefaults\Qt\customColors" $R0
		${EndIf}
		${registry::DeleteKeyEmpty} "HKCU\Software\QtProject\OrganizationDefaults\Qt" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\QtProject\OrganizationDefaults" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\QtProject" $R0
		Goto TheEnd

	LaunchAndExit:
		;SetOutPath "$EXEDIR\Data"
		Exec $EXECSTRING

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd
