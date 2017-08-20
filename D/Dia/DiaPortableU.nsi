;Copyright (C) 2004-2011 John T. Haller
;Copyright (C) 2008-2011 Bart.S

;Website: http://portableapps.com/DiaPortable

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

!define PORTABLEAPPNAME "Dia Portable"
!define APPNAME "Dia"
!define NAME "DiaPortable"
!define VER "1.6.5.0"
!define WEBSITE "PortableApps.com/DiaPortable"
!define DEFAULTEXE "diaw.exe"
!define DEFAULTAPPDIR "Dia"
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
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle On

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParent
!insertmacro GetParameters
!insertmacro GetRoot
!include LogicLib.nsh
;!include WinMessages.nsh
!include WordFunc.nsh
!insertmacro WordFind
;(NSIS Plugins)
!include TextReplace.nsh
;(Custom)
!include ReadINIStrWithDefault.nsh
!include ReplaceInFileWithTextReplace.nsh
;!include CheckForPlatformSplashDisable.nsh

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
Var MISSINGFILEORPATH
Var APPLANGUAGE
Var GTKDIRECTORY
Var EXISTSFILECHOOSER
Var LASTDIRECTORY
Var INTEGRATEDUI
Var DISABLEINTEGRATEDUI

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
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GTKDirectory" "NONE"
		  ${If} $0 == "NONE"
			StrCpy $GTKDIRECTORY "$0"
		  ${Else}
			StrCpy $GTKDIRECTORY "$EXEDIR\$0"
		  ${EndIf}
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $DISABLEINTEGRATEDUI "$EXEDIR\${NAME}.ini" "${NAME}" "DisableIntegratedUI" "false"

		IfFileExists "$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE" FoundProgramEXE

	;NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	FoundProgramEXE:
		;=== Create ExecString
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE"`
		;=== Get any passed parameters
		${GetParameters} $0
		${If} $0 != ""
			StrCpy $EXECSTRING `$EXECSTRING $0`
		${EndIf}
		${If} $DISABLEINTEGRATEDUI != "true"
			StrCpy $EXECSTRING `$EXECSTRING --integrated`
		${EndIf}

		;=== Don't use dia-win-remote without integrated UI (due to registry error)
		${WordFind} $0 "integrated" "#" $1
		${WordFind} $ADDITIONALPARAMETERS "integrated" "#" $2
		${If} $1 >= 1
		${OrIf} $2 >= 1
		${OrIf} $DISABLEINTEGRATEDUI != "true"
			StrCpy $INTEGRATEDUI "true"
		${EndIf}

		;=== Use dia-win-remote for secondary launch (uses an already open dia instance)
		${If} $SECONDARYLAUNCH == "true"
		${AndIf} $INTEGRATEDUI == "true"
			StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\bin\dia-win-remote.exe" "$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE" $0 ""`
			Goto SettingsDirectory
		${EndIf}
		;=== Additional Parameters
		${If} $ADDITIONALPARAMETERS != ""
			StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
		${EndIf}

	SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$SETTINGSDIRECTORY\*.*" GTKDirectory
			CreateDirectory $SETTINGSDIRECTORY
			ClearErrors
			FileOpen $0 "$SETTINGSDIRECTORY\settings_readme.txt" w
			IfErrors GTKDirectory
			FileWrite $0 "Your ${APPNAME} settings files will go here."
			FileClose $0

	GTKDirectory:
		StrCmp $GTKDIRECTORY "NONE" DiaLanguage
		IfFileExists "$GTKDIRECTORY\libgtk-win32*.*" "" DiaLanguage
		ReadEnvStr $0 "PATH"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$0;$GTKDIRECTORY").n'

	DiaLanguage:
		ReadEnvStr $APPLANGUAGE "PortableApps.comLocaleglibc"
		StrCmp $APPLANGUAGE "" DiaLanguageSettingsFile
		StrCmp $APPLANGUAGE "en_US" SetDiaLanguageVariable
		IfFileExists "$PROGRAMDIRECTORY\locale\$APPLANGUAGE\*.*" SetDiaLanguageVariable

	DiaLanguageSettingsFile:
		ReadINIStr $APPLANGUAGE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG"
		StrCmp $APPLANGUAGE "" SetEnvironmentVariables
		StrCmp $APPLANGUAGE "en_US" SetDiaLanguageVariable
		IfFileExists "$PROGRAMDIRECTORY\share\locale\$APPLANGUAGE\*.*" SetDiaLanguageVariable SetEnvironmentVariables

	SetDiaLanguageVariable:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("LANG", "$APPLANGUAGE").n'

	SetEnvironmentVariables:
		;=== Stick Dia's directory into the path, just to make sure it gets its plugins
		ReadEnvStr $0 "PATH"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$0;$PROGRAMDIRECTORY\bin").n'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("HOME", "$SETTINGSDIRECTORY").n'

		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
	;AdjustPaths:
		ReadINIStr $LASTDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory"
		StrCmp $LASTDIRECTORY "" CheckForFileChooser
		StrCmp $LASTDIRECTORY $EXEDIR CheckForFileChooser ;No change -> no adjustment/update necessary
		${GetRoot} $LASTDIRECTORY $0
		${GetRoot} $EXEDIR $1

		${If} ${FileExists} "$SETTINGSDIRECTORY\.dia\pluginrc"
			${ReplaceInFile} "$SETTINGSDIRECTORY\.dia\pluginrc" "$LASTDIRECTORY" "$EXEDIR"
		${EndIf}
		StrCmp $0 $1 CheckForFileChooser
		${If} ${FileExists} "$SETTINGSDIRECTORY\.dia\persistence"
			${ReplaceInFile} "$SETTINGSDIRECTORY\.dia\persistence" "$0\" "$1\"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\.gtk-bookmarks"
			${ReplaceInFile} "$SETTINGSDIRECTORY\.gtk-bookmarks" "file:///$0/" "file:///$1/"
		${EndIf}

	CheckForFileChooser:
		IfFileExists "$APPDATA\gtk-2.0\gtkfilechooser.ini" "" LaunchNow
			StrCpy $EXISTSFILECHOOSER "true"

	LaunchNow:
		;===gdk-pixpuf.loaders Generation (to make sure it has the correct paths inside)  (Thanks to Steffen Macke)
		${If} $LASTDIRECTORY != $EXEDIR
		${OrIfNot} ${FileExists} "$PROGRAMDIRECTORY\etc\gtk-2.0\gdk-pixbuf.loaders"
			SetOutPath "$PROGRAMDIRECTORY\bin"
			FileOpen $0 "$PROGRAMDIRECTORY\bin\gdk-pixbuf-query-loaders.bat" w
			FileWrite $0 ".\gdk-pixbuf-query-loaders.exe > ..\etc\gtk-2.0\gdk-pixbuf.loaders$\r$\n"
			FileClose $0
			ReadEnvStr $0 COMSPEC
			nsExec::ExecToStack '"$0" /c "$PROGRAMDIRECTORY\bin\gdk-pixbuf-query-loaders.bat"'
			Pop $1
			Delete "$PROGRAMDIRECTORY\bin\gdk-pixbuf-query-loaders.bat"
		${EndIf}

		SetOutPath "$EXEDIR\Data"
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory" "$EXEDIR"
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG" "$APPLANGUAGE" 
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 500
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" CheckRunning

	;=== Cleanup
		Delete "$TEMP\dia*0.97*.log"
		StrCmp $EXISTSFILECHOOSER "true" TheEnd
			Delete "$APPDATA\gtk-2.0\gtkfilechooser.ini"
			RmDir "$APPDATA\gtk-2.0\"
		Goto TheEnd

	LaunchAndExit:
		SetOutPath "$EXEDIR\Data"
		Exec $EXECSTRING

	TheEnd:
SectionEnd