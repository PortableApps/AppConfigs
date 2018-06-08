﻿;Copyright 2004-2018 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/FirefoxPortable

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

!define PORTABLEAPPNAME "Mozilla Firefox, Portable Edition"
!define NamePortable "Mozilla Firefox, Portable Edition"
!define APPNAME "Firefox"
!define NAME "FirefoxPortable"
!define AppID "FirefoxPortable"
!define VER "2.1.2.0"
!define WEBSITE "PortableApps.com/FirefoxPortable"
!define DEFAULTEXE "firefox.exe"
!define DEFAULTAPPDIR "firefox"
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
VIAddVersionKey LegalTrademarks "Firefox is a Registered Trademark of The Mozilla Foundation.  PortableApps.com is a Registered Trademark of Rare Ideas, LLC."
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
!include WinVer.nsh
!include WordFunc.nsh
!insertmacro VersionCompare

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
BrandingText "PortableApps.com®"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var PROGRAMDIRECTORY
Var PROGRAMDIRECTORY64
Var PROFILEDIRECTORY
Var ORIGINALPROFILEDIRECTORY
Var SETTINGSDIRECTORY
Var PLUGINSDIRECTORY
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
Var bolHKCUSoftwareMozillaFirefoxCrashReporterExists
Var bolHKCUSoftwareMozillaFirefoxExists
Var bolHKCUSoftwareMozillaExists
Var bolPendingPingsExists
Var SubmitCrashReportBackup
Var bolLauncherIsAlreadyRunning
Var strPassedParameters
Var bolAlwaysUse32Bit
Var bolUsing64Bit
;=== START INTEGRITY CHECK 1.1 Var
Var bolCustomIntegrityCheckStartUnsupported
	Var strCustomIntegrityCheckVersion
;=== END INTEGRITY CHECK

Section .onInit
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0

	${If} $0 == 0
		;SSE2 unavailable
		MessageBox MB_ICONEXCLAMATION|MB_OK "This computer has an older CPU that lacks SSE2 instruction set support. Mozilla Firefox 49 and later can not run on this computer."
		Abort
	${EndIf}

	;=== START INTEGRITY CHECK 1.1 OnInit
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
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `Integrity Failure Warning: ${NamePortable} was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Neither the application publisher nor PortableApps.com will be responsible for any issues you encounter.$\r$\n$\r$\nWould you like to start ${NamePortable} in its current unsupported state?` IDYES CustomIntegrityCheckGotoStartAnyway IDNO CustomIntegrityCheckGotoDownloadQuestion
		
			CustomIntegrityCheckGotoDownloadQuestion:
			;Check to ensure we have a valid homepage before asking the user
			StrCpy $R0 ""
			${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
				ReadINIStr $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Details" "Homepage"
			${EndIf}
			
			${If} $R0 == ""
				Abort
			${Else}
				StrCpy $R1 $R0 4
				${If} $R1 != "http"
				${AndIf} $R1 != "HTTP"
					StrCpy $R0 "http://$R0"
				${EndIf}
			${EndIf}
			
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `Would you like to visit the ${NamePortable} homepage to download the app and upgrade your current install?` IDYES CustomIntegrityCheckGotoURL IDNO CustomIntegrityCheckGotoAbort

			CustomIntegrityCheckGotoURL:		
			ExecShell "open" $R0
			Abort
						
			CustomIntegrityCheckGotoAbort:
			Abort
	
			CustomIntegrityCheckGotoStartAnyway:
			StrCpy $bolCustomIntegrityCheckStartUnsupported true
			StrCpy $strCustomIntegrityCheckVersion $0
		${EndIf}
	${EndIf}
	;=== END INTEGRITY CHECK
SectionEnd

Section "Main"
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
		StrCpy $PROGRAMDIRECTORY64 "$EXEDIR\$064"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "ProfileDirectory" "Data\profile"
		StrCpy $PROFILEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\settings"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
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
		${If} $RUNLOCALLY == "true"
			StrCpy $WAITFORPROGRAM "true"
		${EndIf}
			
		${ReadINIStrWithDefault} $bolAlwaysUse32Bit "$INIPATH\${NAME}.ini" "${NAME}" "AlwaysUse32Bit" "false"
		${If} $bolAlwaysUse32Bit == "true"
			StrCpy $bolAlwaysUse32Bit true
		${Else}
			StrCpy $bolAlwaysUse32Bit false
		${EndIf}

	;CheckIfDefaultDirectories:
		;=== Check if default directories
		StrCmp $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}" "" EndINI
		StrCmp $PROFILEDIRECTORY "$EXEDIR\Data\profile" "" EndINI
		StrCmp $PLUGINSDIRECTORY "$EXEDIR\Data\plugins" "" EndINI
		StrCmp $SETTINGSDIRECTORY "$EXEDIR\Data\settings" "" EndINI
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
		StrCpy $bolAlwaysUse32Bit false

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" CheckPortableProgramDIR
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $PROGRAMDIRECTORY64 "$EXEDIR\App\${DEFAULTAPPDIR}64"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
			StrCpy $ISDEFAULTDIRECTORY "true"
			Goto FoundProgramEXE
	
	CheckPortableProgramDIR:
			IfFileExists "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}"
			StrCpy $PROGRAMDIRECTORY64 "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}64"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\${NAME}\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\${NAME}\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\${NAME}\Data\settings"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	FoundProgramEXE:
		StrCpy $ORIGINALPROFILEDIRECTORY $PROFILEDIRECTORY
		
		IfFileExists "$APPDATA\Mozilla\Firefox\*.*" CheckUserRegistryKey
			StrCpy $WAITFORPROGRAM "true"
		CheckUserRegistryKey:
			${registry::KeyExists} "HKCU\Software\mozilla.org" $R0
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
				${registry::KeyExists} "HKCU\Software\Mozilla\Firefox" $R0
				${If} $R0 != "-1"
					StrCpy $bolHKCUSoftwareMozillaFirefoxExists true
					${registry::KeyExists} "HKCU\Software\Mozilla\Firefox\Crash Reporter" $R0
					${If} $R0 != "-1"
						StrCpy $bolHKCUSoftwareMozillaFirefoxCrashReporterExists true
						${registry::Read} "HKCU\Software\Mozilla\Firefox\Crash Reporter" "SubmitCrashReport" $SubmitCrashReportBackup $R2
					${EndIf}
				${EndIf}	
			${EndIf}
			
		${IfNot} ${FileExists} "$APPDATA\Mozilla\Firefox\Pending Pings\*.*"
			StrCpy $bolPendingPingsExists false
		${EndIf}

	;CheckIfRunning:
		;=== Check if running
		StrCmp $ALLOWMULTIPLEINSTANCES "true" ProfileWork
		FindProcDLL::FindProc "firefox.exe"
		StrCmp $R0 "1" "" CheckForCrashReports
			;=== Is launcher already running?
			StrCmp $bolLauncherIsAlreadyRunning false WarnAnotherInstance
				StrCpy $SECONDARYLAUNCH "true"
				Goto RunProgram

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	CheckForCrashReports:
		IfFileExists "$APPDATA\Mozilla\Firefox\Crash Reports\*.*" "" CheckForExtensionsDirectory
			Rename "$APPDATA\Mozilla\Firefox\Crash Reports" "$APPDATA\Mozilla\Firefox\Crash Reports-BackupByFirefoxPortable"
			StrCpy $CRASHREPORTSDIREXISTS "true"
			StrCpy $WAITFORPROGRAM "true"

	CheckForExtensionsDirectory:
		IfFileExists "$APPDATA\Mozilla\Extensions\*.*" "" ProfileWork
			Rename "$APPDATA\Mozilla\Extensions" "$APPDATA\Mozilla\Extensions-BackupByFirefoxPortable"
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
		CopyFiles /SILENT $EXEDIR\App\DefaultData\plugins\*.* $EXEDIR\Data\plugins
		CopyFiles /SILENT $EXEDIR\App\DefaultData\profile\*.* $EXEDIR\Data\profile
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo ProfileFound
	
	CreateProfile:
		IfFileExists "$PROFILEDIRECTORY\*.*" ProfileFound
		CreateDirectory "$PROFILEDIRECTORY"

	ProfileFound:
		IfFileExists "$SETTINGSDIRECTORY\FirefoxPortableSettings.ini" SettingsFound
			CreateDirectory "$SETTINGSDIRECTORY"
			FileOpen $R0 "$SETTINGSDIRECTORY\FirefoxPortableSettings.ini" w
			FileClose $R0
			WriteINIStr "$SETTINGSDIRECTORY\FirefoxPortableSettings.ini" "FirefoxPortableSettings" "LastProfileDirectory" "NONE"

	SettingsFound:
		${ReadINIStrWithDefault} $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" ""
		${If} $R0 != ""
			${registry::Write} "HKCU\Software\Mozilla\Firefox\Crash Reporter" "SubmitCrashReport" "$R0" "REG_DWORD" $R1
		${EndIf}
		
		;=== START INTEGRITY CHECK 1.1 PrePrimary
		${If} $bolCustomIntegrityCheckStartUnsupported == true
			WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown" $strCustomIntegrityCheckVersion
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
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 2000 0 0 -1 /L $PLUGINSDIR\splash.jpg

	SkipSplashScreen:
		;=== Run locally if needed (aka Portable Firefox Live)
		StrCmp $RUNLOCALLY "true" "" CompareProfilePath
		RMDir /r "$TEMP\${NAME}\"
		CreateDirectory $TEMP\${NAME}\profile
		CreateDirectory $TEMP\${NAME}\plugins
		CreateDirectory $TEMP\${NAME}\program
		CopyFiles /SILENT $PROFILEDIRECTORY\*.* $TEMP\${NAME}\profile
		StrCpy $PROFILEDIRECTORY $TEMP\${NAME}\profile
		CopyFiles /SILENT $PLUGINSDIRECTORY\*.* $TEMP\${NAME}\plugins
		StrCpy $PLUGINSDIRECTORY $TEMP\${NAME}\plugins
		CopyFiles /SILENT $PROGRAMDIRECTORY\*.* $TEMP\${NAME}\program
		StrCpy $PROGRAMDIRECTORY $TEMP\${NAME}\program
		${SetFileAttributesDirectoryNormal} "$TEMP\${NAME}"

	CompareProfilePath:
		ReadINIStr $LASTPROFILEDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory"
		StrCmp $PROFILEDIRECTORY $LASTPROFILEDIRECTORY "" RememberProfilePath
			StrCmp $DISABLEINTELLIGENTSTART "true" RememberProfilePath
				StrCpy $SKIPCOMPREGFIX "true"
	
	RememberProfilePath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" "$PROFILEDIRECTORY"

	;FixPrefsJs:
		IfFileExists "$PROFILEDIRECTORY\prefs.js" "" FixOtherFiles
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

	FixOtherFiles:
		StrCmp $LASTPROFILEDIRECTORY "NONE" RunProgram
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last FirefoxPortable directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current FirefoxPortable directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\pluginreg.dat"
			${ReplaceInFile} "$PROFILEDIRECTORY\pluginreg.dat" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.ini"
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.ini" $0 $1
			;Update extensions SQL
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.sqlite"
			nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$PROFILEDIRECTORY\extensions.sqlite" "UPDATE addon SET descriptor = '$1' || SUBSTR(descriptor,(LENGTH('$0')+1)) WHERE descriptor LIKE '$0%';"`
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\mimeTypes.rdf"
			${ReplaceInFile} "$PROFILEDIRECTORY\mimeTypes.rdf" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\prefs.js"
			${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" $0 $1
			${WordReplace} $0 "\" "/" "+" $2
			${WordReplace} $1 "\" "/" "+" $3
			${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" "file:///$2" "file:///$3"
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.json"
			${WordReplace} $0 "\" "\\" "+" $2
			${WordReplace} $1 "\" "\\" "+" $3
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.json" "$2" "$3"
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
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.json"
			${WordReplace} $0 "\" "\\" "+" $2
			${WordReplace} $1 "\" "\\" "+" $3
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.json" "$2" "$3"
		${EndIf}

	RunProgram:
		StrCmp $SKIPCOMPREGFIX "true" GetPassedParameters

		;=== Delete component registry to ensure compatibility with all extensions
		Delete $PROFILEDIRECTORY\compreg.dat

	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $strPassedParameters

		;=== Setup exec string	
		System::Call kernel32::GetCurrentProcess()i.s
		System::Call kernel32::IsWow64Process(is,*i.r0)
		${If} $0 != 0
		${AndIf} ${FileExists} "$PROGRAMDIRECTORY64\$PROGRAMEXECUTABLE"
		${AndIf} ${AtLeastWin7}
		${AndIf} $bolAlwaysUse32Bit == false
			StrCpy $EXECSTRING `"$PROGRAMDIRECTORY64\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY"`
			StrCpy $bolUsing64Bit true
		${Else}
			StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY"`
			StrCpy $bolUsing64Bit false
		${EndIf}
		
		${If} $strPassedParameters != ''
			StrCpy $EXECSTRING `$EXECSTRING $strPassedParameters`
		${EndIf}
		
	;CheckMultipleInstances:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" "" AdditionalParameters
		StrCpy $EXECSTRING `$EXECSTRING -no-remote`

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
		${If} $bolUsing64Bit == true
			${If} ${FileExists} "$0\CommonFiles\Java64\bin\plugin2\*.*"
				${If} $PLUGINSDIRECTORY != ""
					StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java64\bin\plugin2"
				${Else}
					StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java64\bin\plugin2"
				${EndIf}
			${ElseIf} ${FileExists} "$0\CommonFiles\Java64\bin\new_plugin\*.*"
				${If} $PLUGINSDIRECTORY != ""
					StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java64\bin\new_plugin"
				${Else}
					StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java64\bin\new_plugin"
				${EndIf}
			${EndIf}
		${Else}
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
		
		StrCmp $PLUGINSDIRECTORY "" LaunchNow
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_PLUGIN_PATH", "$PLUGINSDIRECTORY").r0'

	LaunchNow:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_CRASHREPORTER_DATA_DIRECTORY", "$PROFILEDIRECTORY\CrashReports").r0'
		
		StrCmp $SECONDARYLAUNCH "true" StartProgramAndExit
		StrCmp $WAITFORPROGRAM "true" "" StartProgramAndExit
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING

	;CheckRunning:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" CheckIfRemoveLocalFiles
		
	CheckRunning:
		FindProcDLL::WaitProcEnd "firefox.exe" -1
		Sleep 2000
		FindProcDLL::FindProc "firefox.exe"                  
		StrCmp $R0 "1" CheckRunning
		FindProcDLL::FindProc "$PROGRAMDIRECTORY\updater.exe"                  
		StrCmp $R0 "1" CheckRunning
		FindProcDLL::FindProc "$PROGRAMDIRECTORY64\updater.exe"                  
		StrCmp $R0 "1" CheckRunning CleanupRunLocally
	
	StartProgramAndExit:
		SetOutPath $PROGRAMDIRECTORY
		Exec $EXECSTRING
		Goto TheEnd
	
	CleanupRunLocally:
		StrCmp $RUNLOCALLY "true" "" CheckIfRemoveLocalFiles
		RMDir /r "$TEMP\${NAME}\"

	CheckIfRemoveLocalFiles:
		FindProcDLL::FindProc "firefox.exe"
		Pop $R0
		StrCmp $R0 "1" TheEnd RemoveLocalFiles

	RemoveLocalFiles:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles2
		RMDir /r "$APPDATA\Mozilla\Firefox\Crash Reports\"
		Rename "$APPDATA\Mozilla\Firefox\Crash Reports-BackupByFirefoxPortable" "$APPDATA\Mozilla\Firefox\Crash Reports"
		
	RemoveLocalFiles2:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles3
		RMDir /r "$APPDATA\Mozilla\Extensions\"
		Rename "$APPDATA\Mozilla\Extensions-BackupByFirefoxPortable" "$APPDATA\Mozilla\Extensions"
		
	RemoveLocalFiles3:
		Delete "$APPDATA\Mozilla\Firefox\pluginreg.dat"
		${If} $bolPendingPingsExists == false
			RMDir /r "$APPDATA\Mozilla\Firefox\Pending Pings\*.*"
		${EndIf}
		
		RMDir "$APPDATA\Mozilla\Firefox\Pending Pings\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\Firefox\Profiles\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\Firefox\Profile\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\Firefox\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\SystemExtensionsDev\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)	
		RMDir "$LOCALAPPDATA\Mozilla\Firefox\firefox\updates\0" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\Firefox\firefox\updates" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\Firefox\firefox" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\Firefox\" ;=== Will only delete if empty (no /r switch)

		;Remove empty directories left due to a Firefox updater bug
		${If} ${FileExists} "$LOCALAPPDATA\Mozilla\updates\*.*"	
			FindFirst $0 $1 "$LOCALAPPDATA\Mozilla\updates\*.*"
			RemoveLocalFiles3Loop:
				StrCmp $1 "" RemoveLocalFiles3LoopDone
				${If} ${FileExists} "$LOCALAPPDATA\Mozilla\updates\$1\*.*"
				${AndIf} $1 != "."
				${AndIf} $1 != ".."
					RMDir "$LOCALAPPDATA\Mozilla\updates\$1"
				${EndIf}
				FindNext $0 $1
				Goto RemoveLocalFiles3Loop
			RemoveLocalFiles3LoopDone:
			FindClose $0
		${EndIf}
		
		RMDir "$LOCALAPPDATA\Mozilla\updates" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATALow\Mozilla\" ;=== Will only delete if empty (no /r switch)

		StrCmp $MOZILLAORGKEYEXISTS "true" RemoveMachineRegistryKey
			${registry::DeleteKey} "HKEY_CURRENT_USER\Software\mozilla.org" $R0
		RemoveMachineRegistryKey:
			StrCmp $HKLMMOZILLAORGKEYEXISTS "true" RemoveOtherKeys
				${registry::KeyExists} "HKLM\Software\mozilla.org" $R0
					StrCmp $R0 "-1" RemoveOtherKeys ;=== If it doesn't exist, skip the next line
						UserInfo::GetAccountType
						Pop $0
						StrCmp $0 "Guest" RemoveOtherKeys
						StrCmp $0 "User" RemoveOtherKeys
						${registry::DeleteKey} "HKLM\Software\mozilla.org" $R0
		RemoveOtherKeys:
			;Store the crash report setting
			${registry::Read} "HKCU\Software\Mozilla\Firefox\Crash Reporter" "SubmitCrashReport" $R1 $R2
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" "$R1"
			
			${If} $bolHKCUSoftwareMozillaExists == true
				${If} $bolHKCUSoftwareMozillaFirefoxExists == true
					${If} $bolHKCUSoftwareMozillaFirefoxCrashReporterExists == true
						${registry::Write} "HKCU\Software\Mozilla\Firefox\Crash Reporter" "SubmitCrashReport" "$SubmitCrashReportBackup" "REG_DWORD" $R1
					${Else}
						${registry::DeleteKey} "HKCU\Software\Mozilla\Firefox\Crash Reporter" $R0
					${EndIf}
				${Else}
					${registry::DeleteKey} "HKCU\Software\Mozilla\Firefox" $R0
				${EndIf}				
			${Else}
				${registry::DeleteKey} "HKCU\Software\Mozilla" $R0
			${EndIf}

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd