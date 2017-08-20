;Copyright (C) 2004-2015 John T. Haller
;Copyright (C) 2008-2011 Bart.S

;Website: http://portableapps.com/Tipp10Portable

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

!define PORTABLEAPPNAME "Tipp10 Portable"
!define APPNAME "Tipp10"
!define NAME "Tipp10Portable"
!define VER "1.6.5.0"
!define WEBSITE "PortableApps.com/Tipp10Portable"
!define DEFAULTEXE "tipp10.exe"
!define DEFAULTAPPDIR "Tipp10"
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
!insertmacro GetParameters
!include LogicLib.nsh
!include Registry.nsh
!include WinMessages.nsh
;(NSIS Plugins)
;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReadINIStrWithDefault.nsh

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
Var ALLOWMULTIPLEINSTANCES
;Var APPLANGUAGE


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
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$EXEDIR\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"

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
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L "$PLUGINSDIR\splash.jpg"
		${EndIf}

		;=== Create ExecString
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
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
		IfFileExists "$SETTINGSDIRECTORY\*.*" CheckForSettings
			CreateDirectory $SETTINGSDIRECTORY
			ClearErrors
			FileOpen $0 "$SETTINGSDIRECTORY\settings_readme.txt" w
			IfErrors CheckForSettings
			FileWrite $0 "Your ${APPNAME} settings files will go here."
			FileClose $0

	CheckForSettings:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		IfFileExists "$SETTINGSDIRECTORY\*.*" MoveSettings Tipp10Language

	MoveSettings:
		Rename "$SETTINGSDIRECTORY\settings.ini" "$PROGRAMDIRECTORY\portable\settings.ini"
		Rename "$SETTINGSDIRECTORY\tipp10v2.db" "$PROGRAMDIRECTORY\portable\tipp10v2.db"

	Tipp10Language:
		; ReadEnvStr $APPLANGUAGE "PortableApps.comLocaleglibc"
		; StrCmp $APPLANGUAGE "" Tipp10LanguageSettingsFile
		; StrCmp $APPLANGUAGE "en_US" SetTipp10LanguageVariable
		; StrCmp $APPLANGUAGE "de_DE" SetTipp10LanguageVariable

	;Tipp10LanguageSettingsFile:
		; ReadINIStr $APPLANGUAGE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG"
		; StrCmp $APPLANGUAGE "" RegistryBackup
		; StrCmp $APPLANGUAGE "en_US" SetTipp10LanguageVariable
		; StrCmp $APPLANGUAGE "de_DE" SetTipp10LanguageVariable RegistryBackup

	;SetTipp10LanguageVariable:
		; System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("LANG", "$APPLANGUAGE").n'

	;RegistryBackup:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		;${GetRoot} "$EXEDIR" $DRIVEROOT
		;=== Backup the registry
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		StrCmp $R0 "0" LaunchNow
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		StrCmp $R0 "-1" LaunchNow
		${registry::MoveKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		Sleep 100

	LaunchNow:
		SetOutPath $PROGRAMDIRECTORY
		;WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "Language" "LANG" "$APPLANGUAGE" 
		ExecWait $EXECSTRING

	;=== Move settings back
	Sleep 200
	Rename "$SETTINGSDIRECTORY\settings.ini" "$SETTINGSDIRECTORY\settings.ini.bak"
	Rename "$SETTINGSDIRECTORY\tipp10v2.db" "$SETTINGSDIRECTORY\tipp10v2.db.bak"
	Rename "$PROGRAMDIRECTORY\portable\settings.ini" "$SETTINGSDIRECTORY\settings.ini"
	Rename "$PROGRAMDIRECTORY\portable\tipp10v2.db" "$SETTINGSDIRECTORY\tipp10v2.db"

	;SetOriginalKeyBack:
		${registry::DeleteKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		Sleep 100
		${registry::KeyExists} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" $R0
		StrCmp $R0 "-1" CleanupRegistry
		${registry::MoveKey} "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors-BackupBy${NAME}" "HKCU\Software\Trolltech\OrganizationDefaults\Qt\customColors" $R0
		Sleep 100

	CleanupRegistry:
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults\Qt" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech\OrganizationDefaults" $R0
		${registry::DeleteKeyEmpty} "HKCU\Software\Trolltech" $R0
	Goto TheEnd

	LaunchAndExit:
		StrCmp $AllowMultipleInstances "true" LaunchNewInstance
		FindWindow $1 'QWidget' 'TIPP10'
		IntCmp $1 0 LaunchNewInstance
		ShowWindow $1 ${SW_MINIMIZE}
		ShowWindow $1 ${SW_RESTORE}
		Goto TheEnd

	LaunchNewInstance:
		Exec $EXECSTRING

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd