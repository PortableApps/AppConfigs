;Copyright 2004-2017 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/SeaMonkeyPortable

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

!define PF_XMMI64_INSTRUCTIONS_AVAILABLE 10

!define PORTABLEAPPNAME "SeaMonkey, Portable Edition"
!define NamePortable "SeaMonkey, Portable Edition"
!define APPNAME "SeaMonkey"
!define NAME "SeaMonkeyPortable"
!define AppID "SeaMonkeyPortable"
!define VER "2.0.5.0"
!define WEBSITE "PortableApps.com/SeaMonkeyPortable"
!define DEFAULTEXE "seamonkey.exe"
!define DEFAULTAPPDIR "SeaMonkey"
!define DEFAULTGPGPATH "gpg"
!define DEFAULTGPGHOME "gpg"
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
VIAddVersionKey LegalTrademarks "Mozilla, SeaMonkey and the SeaMonkey logo are registered trademarks of Mozilla.  PortableApps.com is a Registered Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle on
Unicode true
ManifestDPIAware true

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters ;Requires NSIS 2.40 or better
!include LogicLib.nsh
!include Registry.nsh
!include TextFunc.nsh
!insertmacro GetParent
!include WordFunc.nsh
!insertmacro WordReplace


;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh
!include SetFileAttributesDirectoryNormal.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
BrandingText "PortableApps.com - Your Digital Life, Anywhere®"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var PROGRAMDIRECTORY
Var PROFILEDIRECTORY
Var ORIGINALPROFILEDIRECTORY
Var SETTINGSDIRECTORY
Var PLUGINSDIRECTORY
Var GPGPATHDIRECTORY
Var GPGHOMEDIRECTORY
Var ADDITIONALPARAMETERS
Var ALLOWMULTIPLEINSTANCES
Var SKIPCOMPREGFIX
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var DISABLESPLASHSCREEN
Var DISABLEINTELLIGENTSTART
Var LOCALHOMEPAGE
Var ISDEFAULTDIRECTORY
Var RUNLOCALLY
Var WAITFORPROGRAM
Var LASTPROFILEDIRECTORY
Var APPDATAPATH
Var SECONDARYLAUNCH
Var MOZILLAORGKEYEXISTS
Var HKLMMOZILLAORGKEYEXISTS
Var MISSINGFILEORPATH
Var CRASHREPORTSDIREXISTS
Var EXTENSIONSDIREXISTS
Var USERTYPE
Var NOUNREADMAILKEY
Var strOriginalTempPath
Var bolHKCUSoftwareMozillaSeaMonkeyCrashReporterExists
Var bolHKCUSoftwareMozillaSeaMonkeyExists
Var bolHKCUSoftwareMozillaExists
Var SubmitCrashReportBackup
Var bolLauncherIsAlreadyRunning

Section "Main"
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0

	${If} $0 == 0
		;SSE2 unavailable
		MessageBox MB_ICONEXCLAMATION|MB_OK "This computer has an older CPU that lacks SSE2 instruction set support. SeaMonkey 2.46 and later can not run on this computer."
		Abort
	${EndIf}

	;=== Create a mutex so we can determine if this specific launcher is already running
	${WordReplace} $EXEDIR "\" "-" "+" $0
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "FirefoxPortable$0") ?e'
	Pop $R0
	${If} $R0 != 0
		StrCpy $bolLauncherIsAlreadyRunning true
	${Else}
		StrCpy $bolLauncherIsAlreadyRunning false
	${EndIf}

	;=== Setup variables
	ReadEnvStr $APPDATAPATH "APPDATA"

	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR"

		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "ProfileDirectory" "Data\profile"
		StrCpy $PROFILEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\settings"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GPGPathDirectory" "App\${DEFAULTGPGPATH}"
		StrCpy $GPGPATHDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $GPGPATHDIRECTORY "$EXEDIR\${NAME}.ini" "${NAME}" "GPGFullPath" "$GPGPATHDIRECTORY"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GPGHomeDirectory" "Data\${DEFAULTGPGHOME}"
		StrCpy $GPGHOMEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $GPGHOMEDIRECTORY "$EXEDIR\${NAME}.ini" "${NAME}" "GPGHomeFullPath" "$GPGHOMEDIRECTORY"

		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "PluginsDirectory" "Data\plugins"
		StrCpy $PLUGINSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$INIPATH\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"
		${ReadINIStrWithDefault} $SKIPCOMPREGFIX "$INIPATH\${NAME}.ini" "${NAME}" "SkipCompregFix" "false"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $WAITFORPROGRAM "$INIPATH\${NAME}.ini" "${NAME}" "WaitFor${APPNAME}" "false"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		${ReadINIStrWithDefault} $DISABLEINTELLIGENTSTART "$INIPATH\${NAME}.ini" "${NAME}" "DisableIntelligentStart" "false"
		${ReadINIStrWithDefault} $LOCALHOMEPAGE "$INIPATH\${NAME}.ini" "${NAME}" "LocalHomepage" ""
		${ReadINIStrWithDefault} $RUNLOCALLY "$INIPATH\${NAME}.ini" "${NAME}" "RunLocally" "false"
		StrCmp $RUNLOCALLY "true" "" CheckIfDefaultDirectories
			StrCpy $WAITFORPROGRAM "true"

	CheckIfDefaultDirectories:
		;=== Check if default directories
		StrCmp $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}" "" EndINI
		StrCmp $PROFILEDIRECTORY "$EXEDIR\Data\profile" "" EndINI
		StrCmp $PLUGINSDIRECTORY "$EXEDIR\Data\plugins" "" EndINI
		StrCmp $SETTINGSDIRECTORY "$EXEDIR\Data\settings" "" EndINI
		StrCmp $GPGPATHDIRECTORY "$EXEDIR\App\${DEFAULTGPGPATH}" "" EndINI
		StrCmp $GPGHOMEDIRECTORY "$EXEDIR\Data\${DEFAULTGPGHOME}" "" EndINI
		StrCpy $ISDEFAULTDIRECTORY "true"
	
	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $ALLOWMULTIPLEINSTANCES "false"
		StrCpy $SKIPCOMPREGFIX "false"
		StrCpy $WAITFORPROGRAM "false"
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $DISABLESPLASHSCREEN "false"
		StrCpy $DISABLEINTELLIGENTSTART "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" CheckPortableProgramDIR
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
			StrCpy $GPGPATHDIRECTORY "$EXEDIR\App\${DEFAULTGPGPATH}"
			StrCpy $GPGHOMEDIRECTORY "$EXEDIR\Data\${DEFAULTGPGHOME}"
			StrCpy $ISDEFAULTDIRECTORY "true"
			Goto FoundProgramEXE
	
	CheckPortableProgramDIR:
			IfFileExists "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\${NAME}\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\${NAME}\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\${NAME}\Data\settings"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Goto TheRealEnd

	FoundProgramEXE:
		StrCpy $ORIGINALPROFILEDIRECTORY $PROFILEDIRECTORY
		IfFileExists "$APPDATA\Mozilla\SeaMonkey\*.*" CheckUserRegistryKey
			StrCpy $WAITFORPROGRAM "true"
		CheckUserRegistryKey:
			${registry::KeyExists} "HKEY_CURRENT_USER\Software\mozilla.org" $R0
			StrCmp $R0 "-1" CheckMachineRegistryKey ;=== If it doesn't exist, skip the next line
			StrCpy $MOZILLAORGKEYEXISTS "true"
		CheckMachineRegistryKey:
			${registry::KeyExists} "HKLM\Software\mozilla.org" $R0
			StrCmp $R0 "-1" CheckOtherKeys ;=== If it doesn't exist, skip the next line
			StrCpy $HKLMMOZILLAORGKEYEXISTS "true"
		CheckOtherKeys:
			${registry::KeyExists} "HKCU\Software\Mozilla" $R0
			${If} $R0 != "-1"
				StrCpy $bolHKCUSoftwareMozillaExists true
				${registry::KeyExists} "HKCU\Software\Mozilla\SeaMonkey" $R0
				${If} $R0 != "-1"
					StrCpy $bolHKCUSoftwareMozillaSeaMonkeyExists true
					${registry::KeyExists} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" $R0
					${If} $R0 != "-1"
						StrCpy $bolHKCUSoftwareMozillaSeaMonkeyCrashReporterExists true
						${registry::Read} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" "SubmitCrashReport" $SubmitCrashReportBackup $R2
					${EndIf}
				${EndIf}	
			${EndIf}

	;CheckIfRunning:
		;=== Check if running
		StrCmp $ALLOWMULTIPLEINSTANCES "true" ProfileWork
		FindProcDLL::FindProc "SeaMonkey.exe"
		StrCmp $R0 "1" "" CheckForCrashReports
			;=== Is launcher already running?
			StrCmp $bolLauncherIsAlreadyRunning false WarnAnotherInstance
				StrCpy $SECONDARYLAUNCH "true"
				Goto RunProgram

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Goto TheRealEnd
	
	CheckForCrashReports:
		IfFileExists "$APPDATA\Mozilla\SeaMonkey\Crash Reports\*.*" "" CheckForExtensionsDirectory
			Rename "$APPDATA\Mozilla\SeaMonkey\Crash Reports" "$APPDATA\Mozilla\SeaMonkey\Crash Reports-BackupBySeaMonkeyPortable"
			StrCpy $CRASHREPORTSDIREXISTS "true"
			StrCpy $WAITFORPROGRAM "true"

	CheckForExtensionsDirectory:
		IfFileExists "$APPDATA\Mozilla\Extensions\*.*" "" ProfileWork
			Rename "$APPDATA\Mozilla\Extensions" "$APPDATA\Mozilla\Extensions-BackupBySeaMonkeyPortable"
			StrCpy $EXTENSIONSDIREXISTS "true"
			StrCpy $WAITFORPROGRAM "true"
	
	ProfileWork:
		;=== Check for an existing profile
		IfFileExists "$PROFILEDIRECTORY\prefs.js" ProfileFound
			;=== No profile was found
			StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultProfile CreateProfile
	
	CopyDefaultProfile:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\plugins"
		CreateDirectory "$EXEDIR\Data\profile"
		CreateDirectory "$EXEDIR\Data\settings"
		CreateDirectory "$EXEDIR\Data\gpg"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\plugins\*.* $EXEDIR\Data\plugins
		CopyFiles /SILENT $EXEDIR\App\DefaultData\profile\*.* $EXEDIR\Data\profile
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo ProfileFound
	
	CreateProfile:
		IfFileExists "$PROFILEDIRECTORY\*.*" ProfileFound
		CreateDirectory "$PROFILEDIRECTORY"

	ProfileFound:
		IfFileExists "$SETTINGSDIRECTORY\SeaMonkeyPortableSettings.ini" SettingsFound
			CreateDirectory "$SETTINGSDIRECTORY"
			FileOpen $R0 "$SETTINGSDIRECTORY\SeaMonkeyPortableSettings.ini" w
			FileClose $R0
			WriteINIStr "$SETTINGSDIRECTORY\SeaMonkeyPortableSettings.ini" "SeaMonkeyPortableSettings" "LastProfileDirectory" "NONE"

	SettingsFound:
		${ReadINIStrWithDefault} $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" ""
		${If} $R0 != ""
			${registry::Write} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" "SubmitCrashReport" "$R0" "REG_DWORD" $R1
		${EndIf}
		
		;=== START INTEGRITY CHECK 1.0
		;Check for improper install/upgrade without running the PA.c Installer which can cause issues
		;Designed to not require ReadINIStrWithDefault which is not included in the PA.c Launcher code
		
		${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
			${If} ${FileExists} "$EXEDIR\App\AppInfo\pac_installer_log.ini"
				ReadINIStr $R0 "$EXEDIR\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info2"
				${If} $R0 == "This file was generated by the PortableApps.com Installer wizard and modified by the official PortableApps.com Installer TM Rare Ideas, LLC as the app was installed."
					StrCpy $R1 "true"
				${Else}
					StrCpy $R1 "false"
				${EndIf}
			${Else}
				StrCpy $R1 "false"
			${EndIf}
		${Else}
			StrCpy $R1 "true"
		${EndIf}
		
		${If} $R1 == "false"
			;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
			ClearErrors
			ReadINIStr $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
			${If} ${Errors}
			${OrIf} $0 == ""
				StrCpy $0 "0.0.0.1"
				ClearErrors
			${EndIf}

			ClearErrors
			ReadINIStr $1 "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown"
			${If} ${Errors}
			${OrIf} $1 == ""
				StrCpy $1 "0.0.0.0"
				ClearErrors
			${EndIf}

			${VersionCompare} $0 $1 $2
			${If} $2 == 1		
				MessageBox MB_OK|MB_ICONEXCLAMATION `Integrity Failure Warning: ${NamePortable} was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Please visit PortableApps.com to obtain the official release of this application to install or upgrade. If you wish to use this application in its current unsupported state, please click OK to continue.`
				WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown" $0
			${EndIf}
		${EndIf}
		;=== END INTEGRITY CHECK
		
		;=== Check for read/write
		StrCmp $RUNLOCALLY "true" DisplaySplash
		ClearErrors
		FileOpen $R0 "$PROFILEDIRECTORY\writetest.temp" w
		IfErrors "" WriteSuccessful
			;== Write failed, so we're read-only
			MessageBox MB_YESNO|MB_ICONQUESTION `$(LauncherAskCopyLocal)` IDYES SwitchToRunLocally
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherNoReadOnly)`
			Abort

	SwitchToRunLocally:
		StrCpy $RUNLOCALLY "true"
		StrCpy $WAITFORPROGRAM "true"
		Goto DisplaySplash
	
	WriteSuccessful:
		FileClose $R0
		Delete "$PROFILEDIRECTORY\writetest.temp"
	
	DisplaySplash:
		InitPluginsDir
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
			;=== Show the splash screen before processing the files
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 2000 0 0 -1 /L $PLUGINSDIR\splash.jpg

	SkipSplashScreen:
		;=== Run locally if needed (aka Portable SeaMonkey Live)
		StrCmp $RUNLOCALLY "true" "" CompareProfilePath
		RMDir /r "$TEMP\${NAME}\"
		CreateDirectory $TEMP\${NAME}\profile
		CreateDirectory $TEMP\${NAME}\plugins
		CreateDirectory $TEMP\${NAME}\program
		CreateDirectory $TEMP\${NAME}\gpghome
		CreateDirectory $TEMP\${NAME}\gpgpath
		CopyFiles /SILENT $PROFILEDIRECTORY\*.* $TEMP\${NAME}\profile
		StrCpy $PROFILEDIRECTORY $TEMP\${NAME}\profile
		CopyFiles /SILENT $PLUGINSDIRECTORY\*.* $TEMP\${NAME}\plugins
		StrCpy $PLUGINSDIRECTORY $TEMP\${NAME}\plugins
		CopyFiles /SILENT $PROGRAMDIRECTORY\*.* $TEMP\${NAME}\program
		StrCpy $PROGRAMDIRECTORY $TEMP\${NAME}\program
		CopyFiles /SILENT $GPGPATHDIRECTORY\*.* $TEMP\${NAME}\gpgpath
		StrCpy $GPGPATHDIRECTORY $TEMP\${NAME}\gpgpath
		CopyFiles /SILENT $GPGHOMEDIRECTORY\*.* $TEMP\${NAME}\gpghome
		StrCpy $GPGHOMEDIRECTORY $TEMP\${NAME}\gpghome
		${SetFileAttributesDirectoryNormal} "$TEMP\${NAME}"

	CompareProfilePath:
		ReadINIStr $LASTPROFILEDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory"
		StrCmp $PROFILEDIRECTORY $LASTPROFILEDIRECTORY "" RememberProfilePath
			StrCmp $DISABLEINTELLIGENTSTART "true" RememberProfilePath
				StrCpy $SKIPCOMPREGFIX "true"
	
	RememberProfilePath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" "$PROFILEDIRECTORY"

	;FixPrefsJs:
		IfFileExists "$PROFILEDIRECTORY\prefs.js" "" FixMimeTypes
		StrCmp $LASTPROFILEDIRECTORY "NONE" FixPrefsJsPart2
		StrCpy $2 $LASTPROFILEDIRECTORY 1 ;Last drive letter
		StrCpy $3 $PROFILEDIRECTORY 1 ;Current drive letter
		StrCmp $2 $3 FixPrefsJsPart2 ;If no change, move on
		
		;=== Replace drive letters without impacting other instances of the letter in prefs.js
		${ReplaceInFileCS} "$PROFILEDIRECTORY\prefs.js" `file:///$2` `file:///$3`
		${ReplaceInFileCS} "$PROFILEDIRECTORY\prefs.js" `", "$2:\\` `", "$3:\\`
	
	FixPrefsJsPart2:
		;=== Be sure the default browser check is disabled
		FileOpen $0 "$PROFILEDIRECTORY\prefs.js" a
		FileSeek $0 0 END
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		FileWrite $0 `user_pref("browser.shell.checkDefaultBrowser", false);`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		StrCmp "$LOCALHOMEPAGE" "" FixPrefsJsClose
		FileWrite $0 `user_pref("browser.startup.homepage", "file:///$EXEDIR/$LOCALHOMEPAGE");`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"

	FixPrefsJsClose:
		FileClose $0 

	FixMimeTypes:
		StrCmp $LASTPROFILEDIRECTORY "NONE" RunProgram
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last SeaMonkeyPortable directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current SeaMonkeyPortable directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\pluginreg.dat"
			${ReplaceInFile} "$PROFILEDIRECTORY\pluginreg.dat" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.ini"
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.ini" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.sqlite"
			nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$PROFILEDIRECTORY\extensions.sqlite" "UPDATE addon SET descriptor = '$1' || SUBSTR(descriptor,(LENGTH('$0')+1)) WHERE descriptor LIKE '$0%';"`
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\mimeTypes.rdf"
			${ReplaceInFile} "$PROFILEDIRECTORY\mimeTypes.rdf" $0 $1
		${EndIf}
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last PortableApps directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current PortableApps directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\mimeTypes.rdf"
			${ReplaceInFile} "$PROFILEDIRECTORY\mimeTypes.rdf" $0 $1
		${EndIf}
	
	RunProgram:
		StrCmp $SKIPCOMPREGFIX "true" GetPassedParameters

		;=== Delete component registry to ensure compatibility with all extensions
		Delete $PROFILEDIRECTORY\compreg.dat

	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY"`
		Goto CheckMultipleInstances

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY" $0`

	CheckMultipleInstances:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" "" AdditionalParameters
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_NO_REMOTE", "1").r0'

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" PluginsEnvironment

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	PluginsEnvironment:
		;=== Set the plugins directory if we have a path
		${IfNot} ${FileExists} "$PLUGINSDIRECTORY\*.*"
			StrCpy $PLUGINSDIRECTORY ""
		${EndIf}
		${GetParent} $EXEDIR $0
		${If} ${FileExists} "$0\CommonFiles\Java\bin\plugin2\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java\bin\plugin2"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java\bin\plugin2"
			${EndIf}
		${ElseIf} ${FileExists} "$0\CommonFiles\Java\bin\new_plugin\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java\bin\new_plugin"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java\bin\new_plugin"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$0\CommonFiles\Silverlight\files\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Silverlight\files"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Silverlight\files"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$0\CommonFiles\Flash\files\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Flash\files"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Flash\files"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$0\CommonFiles\BrowserPlugins\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\BrowserPlugins"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\BrowserPlugins"
			${EndIf}
		${EndIf}
		
		StrCmp $PLUGINSDIRECTORY "" GPGEnvironment
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_PLUGIN_PATH", "$PLUGINSDIRECTORY").r0'
			
	GPGEnvironment:
		;=== Check for shared GPG install in CommonFiles
		${GetParent} $EXEDIR $3 ;This is the PortableAppsPath

		${If} $3 != "" ;Be sure we didn't just GetParent on Root
			${If} ${FileExists} "$3\CommonFiles\GPG\gpg2.exe"
				StrCpy $GPGPATHDIRECTORY "$3\CommonFiles\GPG"
			${EndIf}
		${EndIf}
	
		;=== Set the GPG Environment if the files are present
		${If} ${FileExists} "$GPGPATHDIRECTORY\gpg.exe"
		${OrIf} ${FileExists} "$GPGPATHDIRECTORY\gpg2.exe"

			;=== Setup the Path so that gpg.exe can be found by Enigmail
			ReadEnvStr $R0 "PATH"
			StrCpy $R0 "$GPGPATHDIRECTORY;$R0"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$R0").r0'

			;=== Setup GNUPGHOME so that we don't have to use the registry
			StrCpy $R0 "$GPGHOMEDIRECTORY"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GNUPGHOME", "$R0").r0'
			
			IfFileExists "$PROFILEDIRECTORY\prefs.js" "" LaunchNow
				FileOpen $0 "$PROFILEDIRECTORY\prefs.js" a
				FileSeek $0 0 END
				FileWriteByte $0 "13"
				FileWriteByte $0 "10"
				${If} ${FileExists} "$GPGPATHDIRECTORY\gpg.exe"
					${WordReplace} "$GPGPATHDIRECTORY\gpg.exe" "\" "\\" "+" $1
				${Else}
					${WordReplace} "$GPGPATHDIRECTORY\gpg2.exe" "\" "\\" "+" $1
				${EndIf}
				FileWrite $0 `user_pref("extensions.enigmail.agentPath", "$1");`
				FileWriteByte $0 "13"
				FileWriteByte $0 "10"
				FileClose $0
		${EndIf}

	LaunchNow:
		StrCmp $SECONDARYLAUNCH "true" StartProgramAndExit
		StrCmp $WAITFORPROGRAM "true" "" StartProgramAndExit
		UserInfo::GetAccountType
		Pop $0
		StrCpy $USERTYPE $0
		StrCmp $USERTYPE "Guest" StartProgramNow
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		StrCmp $R0 "-1" +3 ;=== If it doesn't exist, skip the next line
			${registry::CopyKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupBySeaMonkeyPortable" $R0
		Goto +2
			StrCpy $NOUNREADMAILKEY "true"
		Goto StartProgramNow
	
	StartProgramNow:
		ReadEnvStr $strOriginalTempPath TEMP
		CreateDirectory "$PLUGINSDIR\ContainedTemp"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$PLUGINSDIR\ContainedTemp").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$PLUGINSDIR\ContainedTemp").r0'
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 2000
		StrCmp $ALLOWMULTIPLEINSTANCES "true" CheckIfRemoveLocalFiles
		FindProcDLL::FindProc "SeaMonkey.exe"                  
		StrCmp $R0 "1" CheckRunning CleanupRunLocally
	
	StartProgramAndExit:
		ReadEnvStr $strOriginalTempPath TEMP
		CreateDirectory "$PLUGINSDIR\ContainedTemp"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$PLUGINSDIR\ContainedTemp").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$PLUGINSDIR\ContainedTemp").r0'
		SetOutPath $PROGRAMDIRECTORY
		Exec $EXECSTRING
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$strOriginalTempPath").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$strOriginalTempPath").r0'
		Goto TheRealEnd
	
	CleanupRunLocally:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$strOriginalTempPath").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$strOriginalTempPath").r0'
		StrCmp $RUNLOCALLY "true" "" CheckIfRemoveLocalFiles
		RMDir /r "$TEMP\${NAME}\"

	CheckIfRemoveLocalFiles:
		FindProcDLL::FindProc "seamonkey.exe"
		Pop $R0
		StrCmp $R0 "1" TheEnd RemoveLocalFiles

	RemoveLocalFiles:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles2
		RMDir /r "$APPDATA\Mozilla\SeaMonkey\Crash Reports\"
		Rename "$APPDATA\Mozilla\SeaMonkey\Crash Reports-BackupBySeaMonkeyPortable" "$APPDATA\Mozilla\SeaMonkey\Crash Reports"
		
	RemoveLocalFiles2:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles3
		RMDir /r "$APPDATA\Mozilla\Extensions\"
		Rename "$APPDATA\Mozilla\Extensions-BackupBySeaMonkeyPortable" "$APPDATA\Mozilla\Extensions"
		
	RemoveLocalFiles3:
		Delete "$APPDATA\Mozilla\SeaMonkey\pluginreg.dat"
		RMDir "$APPDATA\Mozilla\SeaMonkey\Profiles\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\SeaMonkey\Profile\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\SeaMonkey\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\Extensions\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\gnupg\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\SeaMonkey\seamonkey\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\SeaMonkey\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\Extensions\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)
		StrCmp $MOZILLAORGKEYEXISTS "true" RemoveMachineRegistryKey
			${registry::DeleteKey} "HKEY_CURRENT_USER\Software\mozilla.org" $R0
		RemoveMachineRegistryKey:
			StrCmp $HKLMMOZILLAORGKEYEXISTS "true" RemoveOtherKeys
				UserInfo::GetAccountType
				Pop $0
				StrCmp $0 "Guest" RemoveOtherKeys
				StrCmp $0 "User" RemoveOtherKeys
				${registry::DeleteKey} "HKLM\Software\mozilla.org" $R0
	RemoveOtherKeys:
	;Store the crash report setting
	${registry::Read} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" "SubmitCrashReport" $R1 $R2
	WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" "$R1"
	
	${If} $bolHKCUSoftwareMozillaExists == true
		${If} $bolHKCUSoftwareMozillaSeaMonkeyExists == true
			${If} $bolHKCUSoftwareMozillaSeaMonkeyCrashReporterExists == true
				${registry::Write} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" "SubmitCrashReport" "$SubmitCrashReportBackup" "REG_DWORD" $R1
			${Else}
				${registry::DeleteKey} "HKCU\Software\Mozilla\SeaMonkey\Crash Reporter" $R0
			${EndIf}
		${Else}
			${registry::DeleteKey} "HKCU\Software\Mozilla\SeaMonkey" $R0
		${EndIf}				
	${Else}
		${registry::DeleteKey} "HKCU\Software\Mozilla" $R0
	${EndIf}

	TheEnd:
		RMDir /r "$PLUGINSDIR\ContainedTemp"
		;=== Restore registry keys
		;StrCmp $USERTYPE "Guest" TheRealEnd
		;${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupBySeaMonkeyPortable" $R0
		;StrCmp $R0 "-1" +4 ;=== If it doesn't exist, skip the next 3 lines
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		Sleep 100
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupBySeaMonkeyPortable" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		${If} ${FileExists} "$GPGPATHDIRECTORY\GPGShutdown.exe"
			ExecWait "$GPGPATHDIRECTORY\GPGShutdown.exe"
		${EndIf}
		StrCmp $NOUNREADMAILKEY "true" 0 +2
			${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		Goto TheRealEnd
	
	TheRealEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd