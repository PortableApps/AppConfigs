;Copyright (C) 2004-2015 John T. Haller
;Copyright (C) 2008-2015 Bart.S

;Website: http://portableapps.com/GrampsPortable

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

!define PORTABLEAPPNAME "Gramps Portable"
!define APPNAME "Gramps"
!define NAME "GrampsPortable"
!define VER "1.6.12.0"
!define WEBSITE "PortableApps.com/GrampsPortable"
!define DEFAULTEXE "gramps.py"
!define DEFAULTAPPDIR "Gramps"
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
!insertmacro WordReplace
;!insertmacro WordFind
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
Var MISSINGFILEORPATH
Var APPLANGUAGE
Var GTKDIRECTORY
Var PYTHONDIRECTORY
Var GRAPHVIZDIRECTORY
Var GHOSTSCRIPTDIRECTORY
Var EXISTSFILECHOOSER
Var EXISTSRECENTLYUSED
Var LASTDIRECTORY
Var DISABLESPLASHSCREEN
Var ALLOWMULTIPLEINSTANCES
Var CONSOLE

Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckForLocalCopy
		StrCpy $SECONDARYLAUNCH "true"
;		Goto CheckINI

	CheckForLocalCopy:
;		FindProcDLL::FindProc "${DEFAULTEXE}"
;		StrCmp $R0 "1" WarnAnotherInstance CheckINI

;	WarnAnotherInstance:
;		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
;		Abort

;	CheckINI:
		;=== Read the parameters from the INI file, if there is one
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GTKDirectory" "App\GTK"
			StrCpy $GTKDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "PythonDirectory" "App\Python27"
			StrCpy $PYTHONDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GraphvizDirectory" "App\Graphviz"
			StrCpy $GRAPHVIZDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GhostscriptDirectory" "App\Ghostscript"
			StrCpy $GHOSTSCRIPTDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$EXEDIR\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"
		${ReadINIStrWithDefault} $CONSOLE "$EXEDIR\${NAME}.ini" "${NAME}" "Console" "false"

		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

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
			newadvsplash::show /NOUNLOAD 3000 0 0 -1 /L "$PLUGINSDIR\splash.jpg"
		${EndIf}

		;=== Create ExecString
		${If} $CONSOLE != "true"
			StrCpy $EXECSTRING `"$PYTHONDIRECTORY\pythonw.exe" -O "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		${Else}
			StrCpy $EXECSTRING `"$PYTHONDIRECTORY\python.exe" -O "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		${EndIf}
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
		IfFileExists "$SETTINGSDIRECTORY\*.*" GraphvizDirectory
			CreateDirectory $SETTINGSDIRECTORY
			ClearErrors
			FileOpen $0 "$SETTINGSDIRECTORY\settings_readme.txt" w
			IfErrors GraphvizDirectory
			FileWrite $0 "Your ${APPNAME} settings files will go here."
			FileClose $0

	GraphvizDirectory:
		${GetParent} $EXEDIR $1
		${If} ${FileExists} "$GRAPHVIZDIRECTORY\bin\*.*"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$GRAPHVIZDIRECTORY\bin;$0").n'
		${ElseIf} ${FileExists} "$1\GraphvizPortable\App\Graphviz\bin\dot.exe"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$1\GraphvizPortable\App\Graphviz\bin;$0").n'
		${EndIf}
	
	;GhostscriptDirectory:
		${GetParent} $EXEDIR $1
		${If} ${FileExists} "$GHOSTSCRIPTDIRECTORY\bin\gswin32.exe"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$GHOSTSCRIPTDIRECTORY\bin;$0").n'
		${ElseIf} ${FileExists} "$1\CommonFiles\Ghostscript\bin\gswin32.exe"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$1\CommonFiles\Ghostscript\bin;$0").n'
		${EndIf}
		
	;PythonDirectory:
		${If} ${FileExists} "$PYTHONDIRECTORY\pythonw.exe"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$PYTHONDIRECTORY;$0").n'
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PYTHON_BASEPATH", "$PYTHONDIRECTORY").n'
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PYTHONPATH", "$PYTHONDIRECTORY").n'
		${EndIf}
	
	;GTKDirectory:
		${If} ${FileExists} "$GTKDIRECTORY\bin\libgtk-win32*.*"
			ReadEnvStr $0 "PATH"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$GTKDIRECTORY\bin;$0").n'
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GTK_BASEPATH", "$GTKDIRECTORY").n'
		${EndIf}

	;GrampsLanguage:
		ReadEnvStr $APPLANGUAGE "PortableApps.comLocaleglibc"
		StrCmp $APPLANGUAGE "" GrampsLanguageSettingsFile
		StrCmp $APPLANGUAGE "en_US" SetGrampsLanguageVariable
		StrCmp $APPLANGUAGE "en_GB" SetGrampsLanguageVariable
		IfFileExists "$PROGRAMDIRECTORY\lang\$APPLANGUAGE\*.*" SetGrampsLanguageVariable

	GrampsLanguageSettingsFile:
		ReadINIStr $APPLANGUAGE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG"
		StrCmp $APPLANGUAGE "" SetEnvironmentVariables
		StrCmp $APPLANGUAGE "en_US" SetGrampsLanguageVariable
		IfFileExists "$GTKDIRECTORY\share\locale\$APPLANGUAGE\*.*" SetGrampsLanguageVariable SetEnvironmentVariables

	SetGrampsLanguageVariable:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("LANG", "$APPLANGUAGE.UTF-8").n'
		;System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("LANGUAGE", "$APPLANGUAGE.UTF-8").n'

	SetEnvironmentVariables:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("HOME", "$SETTINGSDIRECTORY").n'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GRAMPSHOME", "$SETTINGSDIRECTORY").n'
		;System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GRAMPSDIR", "$PROGRAMDIRECTORY").n'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GRAMPSI18N", "$PROGRAMDIRECTORY\lang").n'

		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
	;AdjustPaths:
		ReadINIStr $LASTDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory"
		StrCmp $LASTDIRECTORY "" CheckForFileChooser
		StrCmp $LASTDIRECTORY $EXEDIR CheckForFileChooser ;No change -> no adjustment/update necessary
			${GetRoot} $LASTDIRECTORY $0
			${GetRoot} $EXEDIR $1
			${WordReplace} "$LASTDIRECTORY" "\" "\\" "+" $2
			${WordReplace} "$EXEDIR" "\" "\\" "+" $3

		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\gramps34\gramps.ini"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\gramps34\gramps.ini" "$2" "$3"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\recent-files-gramps.xml"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\recent-files-gramps.xml" "$LASTDIRECTORY" "$EXEDIR"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\report_options.xml"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\report_options.xml" "$LASTDIRECTORY" "$EXEDIR"
		${EndIf}
		StrCmp $0 $1 CheckForFileChooser
		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\gramps34\gramps.ini"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\gramps34\gramps.ini" "='$0\\" "='$1\\"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\gramps34\gramps.ini" "=u'$0\\" "=u'$1\\"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\recent-files-gramps.xml"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\recent-files-gramps.xml" "<Path>$0\" "<Path>$1\"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\gramps\report_options.xml"
			${ReplaceInFile} "$SETTINGSDIRECTORY\gramps\report_options.xml" "$0\" "$1\"
		${EndIf}
		${If} ${FileExists} "$SETTINGSDIRECTORY\.gtk-bookmarks"
			${ReplaceInFile} "$SETTINGSDIRECTORY\.gtk-bookmarks" "file:///$0/" "file:///$1/"
		${EndIf}

	CheckForFileChooser:
		${If} ${FileExists} "$LOCALAPPDATA\gtk-2.0\gtkfilechooser.ini"
			StrCpy $EXISTSFILECHOOSER "true"
		${EndIf}
		;Check for other files
		${If} ${FileExists} "$LOCALAPPDATA\recently-used.xbel"
			StrCpy $EXISTSRECENTLYUSED "true"	
		${EndIf}
			
	;LaunchNow:
		SetOutPath "$PYTHONDIRECTORY"
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory" "$EXEDIR"
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG" "$APPLANGUAGE"
		ExecWait $EXECSTRING

;	CheckRunning:
;		Sleep 500
;		FindProcDLL::FindProc "pythonw.exe"
;		StrCmp $R0 "1" CheckRunning

	;=== Cleanup
		${If} $EXISTSFILECHOOSER != "true"
			Delete "$LOCALAPPDATA\gtk-2.0\gtkfilechooser.ini"
			RmDir "$LOCALAPPDATA\gtk-2.0\"
		${EndIf}
		${If} $EXISTSRECENTLYUSED != "true"
			Delete "$LOCALAPPDATA\recently-used.xbel"
		${EndIf}
		Goto TheEnd

	LaunchAndExit:
		StrCmp $AllowMultipleInstances "true" "" TheEnd
		SetOutPath "$PYTHONDIRECTORY"
		Exec $EXECSTRING

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd
