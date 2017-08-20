;Copyright (C) 2004-2013 John T. Haller
;Copyright (C) 2008-2013 Bart.S

;Website: http://portableapps.com/FreeMatPortable

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

!define PORTABLEAPPNAME "FreeMat Portable"
!define APPNAME "FreeMat"
!define NAME "FreeMatPortable"
!define VER "1.6.3.0"
!define WEBSITE "PortableApps.com/FreeMatPortable"
!define DEFAULTEXE "FreeMat.exe"
!define DEFAULTAPPDIR "FreeMat"
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
!include WordFunc.nsh
!insertmacro WordReplace
!include FileFunc.nsh
!insertmacro GetRoot
!insertmacro GetParameters
!include LogicLib.nsh
!include Registry.nsh
!include WinMessages.nsh
;(NSIS Plugins)
;(Custom)
!include ReadINIStrWithDefault.nsh
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
Var FAILEDTORESTOREKEY
Var DRIVEROOT
Var LASTDRIVEROOT
Var LASTDIRECTORY
Var ALLOWMULTIPLEINSTANCES
Var LASTDIR
Var DIR

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
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$EXEDIR\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "true"

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
			newadvsplash::show /NOUNLOAD 2000 0 0 -1 /L "$PLUGINSDIR\splash.jpg"
		${EndIf}

		;=== Create ExecString
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\bin\$PROGRAMEXECUTABLE"`
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
		IfFileExists "$SETTINGSDIRECTORY\*.*" RegistryBackup
			CreateDirectory $SETTINGSDIRECTORY
			ClearErrors
			FileOpen $0 "$SETTINGSDIRECTORY\settings_readme.txt" w
			IfErrors RegistryBackup
			FileWrite $0 "Your ${APPNAME} settings files will go here."
			FileClose $0

	RegistryBackup:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		${GetRoot} "$EXEDIR" $DRIVEROOT
		;=== Backup the registry
		${registry::KeyExists} "HKCU\Software\${APPNAME}-BackupBy${NAME}" $R0
		StrCmp $R0 "0" RegistryBackup2
		${registry::KeyExists} "HKCU\Software\${APPNAME}" $R0
		StrCmp $R0 "-1" RegistryBackup2
		${registry::MoveKey} "HKCU\Software\${APPNAME}" "HKCU\Software\${APPNAME}-BackupBy${NAME}" $R0
		Sleep 100

	RegistryBackup2:
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		StrCmp $R0 "0" RestoreTheKey
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		StrCmp $R0 "-1" RestoreTheKey
		${registry::MoveKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		Sleep 100

	RestoreTheKey:
		IfFileExists "$SETTINGSDIRECTORY\${NAME}.reg" "" LaunchNow

		${If} ${FileExists} "$WINDIR\system32\reg.exe"
			nsExec::ExecToStack `"$WINDIR\system32\reg.exe" import "$SETTINGSDIRECTORY\${NAME}.reg"`
			Pop $R0
			StrCmp $R0 '0' AdjustKeys	;successfully restored key
		${EndIf}
		${registry::RestoreKey} "$SETTINGSDIRECTORY\{NAME}.reg" $R0
		StrCmp $R0 '0' AdjustKeys	;successfully restored key
		StrCpy $FAILEDTORESTOREKEY "true"

	AdjustKeys:
		IfFileExists "$SETTINGSDIRECTORY\${NAME}Settings.ini" "" LaunchNow
			ReadINIStr $LASTDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory"
			StrCmp $LASTDIRECTORY "$EXEDIR" LaunchNow
			StrCmp $LASTDIRECTORY "" LaunchNow

		${GetRoot} $LASTDIRECTORY $LASTDRIVEROOT
		${GetRoot} $EXEDIR $DRIVEROOT
		${WordReplace} "$LASTDIRECTORY" "\" "/" "+" $LASTDIR
		${WordReplace} "$EXEDIR" "\" "/" "+" $DIR

		${registry::Read} "HKCU\Software\${APPNAME}\FreeMat v4.2\mainwindow" "cdlist" $0 $1
		${If} $0 != ""
			${WordReplace} $0 "$LASTDIR" "$DIR" "+" $2
			${WordReplace} $2 "$LASTDRIVEROOT" "$DRIVEROOT" "+" $3
			${registry::Write} "HKCU\Software\${APPNAME}\FreeMat v4.2\mainwindow" "cdlist" $3 $1 $R0
			Sleep 100
		${EndIf}

		${registry::Read} "HKCU\Software\${APPNAME}\FreeMat v4.2\editor" "recentFileList" $0 $1
		${If} $0 != ""
			${WordReplace} $0 "$LASTDIR" "$DIR" "+" $2
			${WordReplace} $2 "$LASTDRIVEROOT" "$DRIVEROOT" "+" $3
			${registry::Write} "HKCU\Software\${APPNAME}\FreeMat v4.2\editor" "recentFileList" $3 $1 $R1
			Sleep 100
		${EndIf}

		${registry::Read} "HKCU\Software\${APPNAME}\FreeMat v4.2\editor" "last_session_list" $0 $1
		${If} $0 != ""
			${WordReplace} $0 "$LASTDIR" "$DIR" "+" $2
			${WordReplace} $2 "$LASTDRIVEROOT" "$DRIVEROOT" "+" $3
			${registry::Write} "HKCU\Software\${APPNAME}\FreeMat v4.2\editor" "last_session_list" $3 $1 $R2
			Sleep 100
		${EndIf}

		${registry::Read} "HKCU\Software\${APPNAME}\FreeMat v4.2\interpreter" "path" $0 $1
		${If} $0 != ""
			${WordReplace} $0 "$LASTDIR" "$DIR" "+" $2
			${WordReplace} $2 "$LASTDRIVEROOT" "$DRIVEROOT" "+" $3
			${registry::Write} "HKCU\Software\${APPNAME}\FreeMat v4.2\interpreter" "path" $3 $1 $R3
			Sleep 100
		${EndIf}

		${registry::Read} "HKCU\Software\${APPNAME}\FreeMat v4.2" "root" $0 $1
		${If} $0 != ""
			${WordReplace} $0 "$LASTDIR" "$DIR" "+" $2
			${WordReplace} $2 "$LASTDRIVEROOT" "$DRIVEROOT" "+" $3
			${registry::Write} "HKCU\Software\${APPNAME}\FreeMat v4.2" "root" $3 $1 $R4
			Sleep 100
		${EndIf}

	LaunchNow:
		SetOutPath "$EXEDIR\Data"
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" CheckRunning

		StrCmp $FAILEDTORESTOREKEY "true" SetOriginalKeyBack2
		${registry::SaveKey} "HKCU\Software\${APPNAME}" "$SETTINGSDIRECTORY\${NAME}.reg" "" $0
		Sleep 100
		${registry::SaveKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" "$SETTINGSDIRECTORY\${NAME}.reg" "/A=1" $0
		Sleep 100
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDirectory" "$EXEDIR"
		
	SetOriginalKeyBack2:
		${registry::DeleteKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		Sleep 100
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		StrCmp $R0 "-1" CleanupRegistry
		${registry::MoveKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		Sleep 100

	CleanupRegistry:
		${registry::DeleteKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt Factory Cache 4.8\com.trolltech.Qt.QImageIOHandlerFactoryInterface:\$DRIVEROOT" $R0
		${registry::DeleteKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt Plugin Cache 4.8.false\$DRIVEROOT" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults\Qt Plugin Cache 4.8.false" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults\Qt Factory Cache 4.8\com.trolltech.Qt.QImageIOHandlerFactoryInterface:" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults\Qt Factory Cache 4.8" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults\Qt" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech" $R0

	;SetOriginalKeyBack:
		${registry::DeleteKey} "HKCU\Software\${APPNAME}" $R0
		Sleep 100
		${registry::KeyExists} "HKCU\Software\${APPNAME}-BackupBy${NAME}" $R0
		StrCmp $R0 "-1" TheEnd
		${registry::MoveKey} "HKCU\Software\${APPNAME}-BackupBy${NAME}" "HKCU\Software\${APPNAME}" $R0
		Sleep 100
		Goto TheEnd

	LaunchAndExit:
		StrCmp $AllowMultipleInstances "true" LaunchNewInstance
		FindWindow $1 '' 'FreeMat v4.2 Command Window'
		IntCmp $1 0 LaunchNewInstance
		ShowWindow $1 ${SW_MINIMIZE}
		ShowWindow $1 ${SW_RESTORE}
		Goto TheEnd

	LaunchNewInstance:
		SetOutPath "$EXEDIR\Data"
		Exec $EXECSTRING

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd