;Copyright 2004-2016 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/ThunderbirdPortable

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

!define PORTABLEAPPNAME "Mozilla Thunderbird, Portable Edition"
!define APPNAME "Thunderbird"
!define NAME "ThunderbirdPortable"
!define VER "1.9.1.0"
!define WEBSITE "PortableApps.com/ThunderbirdPortable"
!define DEFAULTEXE "thunderbird.exe"
!define DEFAULTAPPDIR "thunderbird"
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
VIAddVersionKey LegalTrademarks "Thunderbird is a Trademark of The Mozilla Foundation.  PortableApps.com is a Trademark of Rare Ideas, LLC."
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
Unicode true
ManifestDPIAware true

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On


;=== Include
;(Standard NSIS)
!include LogicLib.nsh
!include Registry.nsh
!include TextFunc.nsh
!insertmacro GetParent
!insertmacro GetParameters
!include WordFunc.nsh
!insertmacro VersionCompare
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
Var DISABLESPLASHSCREEN
Var DISABLEINTELLIGENTSTART
Var ISDEFAULTDIRECTORY
Var RUNLOCALLY
Var WAITFORPROGRAM
Var LASTPROFILEDIRECTORY
Var SECONDARYLAUNCH
Var USERTYPE
Var MISSINGFILEORPATH
Var NOUNREADMAILKEY
Var strOriginalTempPath
Var bolLauncherIsAlreadyRunning

Section "Main"
	;=== Create a mutex so we can determine if this specific launcher is already running
	${WordReplace} $EXEDIR "\" "-" "+" $0
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "ThunderbirdPortable$0") ?e'
	Pop $R0
	${If} $R0 != 0
		StrCpy $bolLauncherIsAlreadyRunning true
	${Else}
		StrCpy $bolLauncherIsAlreadyRunning false
	${EndIf}

	;=== Find the INI file, if there is one
	IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI

		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "ProfileDirectory" "Data\profile"
		StrCpy $PROFILEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\settings"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GPGPathDirectory" "App\${DEFAULTGPGPATH}"
		StrCpy $GPGPATHDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $GPGPATHDIRECTORY "$EXEDIR\${NAME}.ini" "${NAME}" "GPGFullPath" "$GPGPATHDIRECTORY"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "GPGHomeDirectory" "Data\${DEFAULTGPGHOME}"
		StrCpy $GPGHOMEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $GPGHOMEDIRECTORY "$EXEDIR\${NAME}.ini" "${NAME}" "GPGHomeFullPath" "$GPGHOMEDIRECTORY"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "PluginsDirectory" "Data\plugins"
		StrCpy $PLUGINSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$EXEDIR\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"
		${ReadINIStrWithDefault} $SKIPCOMPREGFIX "$EXEDIR\${NAME}.ini" "${NAME}" "SkipCompregFix" "false"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $WAITFORPROGRAM "$EXEDIR\${NAME}.ini" "${NAME}" "WaitFor${APPNAME}" "false"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		${ReadINIStrWithDefault} $DISABLEINTELLIGENTSTART "$EXEDIR\${NAME}.ini" "${NAME}" "DisableIntelligentStart" "false"
		${ReadINIStrWithDefault} $RUNLOCALLY "$EXEDIR\${NAME}.ini" "${NAME}" "RunLocally" "false"
		StrCmp $RUNLOCALLY "true" "" CheckForDefault
			StrCpy $WAITFORPROGRAM "true"
		
		CheckForDefault:
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

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
			StrCpy $GPGPATHDIRECTORY "$EXEDIR\App\${DEFAULTGPGPATH}"
			StrCpy $GPGHOMEDIRECTORY "$EXEDIR\Data\${DEFAULTGPGHOME}"
			StrCpy $ISDEFAULTDIRECTORY "true"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		StrCpy $ORIGINALPROFILEDIRECTORY $PROFILEDIRECTORY
		;=== Check if running
		StrCmp $ALLOWMULTIPLEINSTANCES "true" ProfileWork
		FindProcDLL::FindProc "thunderbird.exe"
		StrCmp $R0 "1" "" ProfileWork
			;=== Is launcher already running?
			StrCmp $bolLauncherIsAlreadyRunning false WarnAnotherInstance
				StrCpy $SECONDARYLAUNCH "true"
				Goto RunProgram
		
	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	ProfileWork:
	;=== Check for an existing profile
	IfFileExists "$PROFILEDIRECTORY\prefs.js" ProfileFound
		;=== No profile was found
		StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultProfile CreateProfile
	
	CopyDefaultProfile:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\plugins"
		CreateDirectory "$EXEDIR\Data\profile"
		CreateDirectory "$EXEDIR\Data\gpg"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\plugins\*.* $EXEDIR\Data\plugins
		CopyFiles /SILENT $EXEDIR\App\DefaultData\profile\*.* $EXEDIR\Data\profile
		CopyFiles /SILENT $EXEDIR\App\DefaultData\gpg\*.* $EXEDIR\Data\gpg
		IfFileExists "$EXEDIR\Data\settings\ThunderbirdPortableSettings.ini" ProfileFound
			CreateDirectory "$EXEDIR\Data\settings"
			CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo ProfileFound
	
	CreateProfile:
		IfFileExists "$PROFILEDIRECTORY\*.*" ProfileFound
		CreateDirectory "$PROFILEDIRECTORY"

	ProfileFound:
		IfFileExists "$SETTINGSDIRECTORY\ThunderbirdPortableSettings.ini" SettingsFound
			CreateDirectory "$SETTINGSDIRECTORY"
			FileOpen $R0 "$SETTINGSDIRECTORY\ThunderbirdPortableSettings.ini" w
			FileClose $R0
			WriteINIStr "$SETTINGSDIRECTORY\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "LastProfileDirectory" "NONE"
			
	SettingsFound:
		${If} ${FileExists} "$EXEDIR\LupoApp.ini"
			;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
			${ReadINIStrWithDefault} $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion" "0.0.0.0"
			${ReadINIStrWithDefault} $1 "$SETTINGSDIRECTORY\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "InvalidPackageWarningShown" "0.0.0.0"
			${VersionCompare} $0 $1 $2
			${If} $2 == 1
				MessageBox MB_OK|MB_ICONEXCLAMATION `Warning: ${PORTABLEAPPNAME} was installed or upgraded without using the official PortableApps.com Installer which can cause compatibility issues and may be a violation of the application's license. You may encounter issues while using this application. Please visit PortableApps.com to obtain the official release of this application to install or upgrade.`
				WriteINIStr "$SETTINGSDIRECTORY\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "InvalidPackageWarningShown" $0
			${EndIf}
		${EndIf}
	
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
		;=== Run locally if needed (aka Portable Thunderbird Live)
		StrCmp $RUNLOCALLY "true" "" CompareProfilePath
			RMDir /r "$PLUGINSDIR\${NAME}\"
			CreateDirectory $PLUGINSDIR\${NAME}\profile
			CreateDirectory $PLUGINSDIR\${NAME}\plugins
			CreateDirectory $PLUGINSDIR\${NAME}\program
			CreateDirectory $PLUGINSDIR\${NAME}\gpghome
			CreateDirectory $PLUGINSDIR\${NAME}\gpgpath
			CreateDirectory $PLUGINSDIR\${NAME}\registry
			CopyFiles /SILENT $PROFILEDIRECTORY\*.* $PLUGINSDIR\${NAME}\profile
			StrCpy $PROFILEDIRECTORY $PLUGINSDIR\${NAME}\profile
			CopyFiles /SILENT $PLUGINSDIRECTORY\*.* $PLUGINSDIR\${NAME}\plugins
			StrCpy $PLUGINSDIRECTORY $PLUGINSDIR\${NAME}\plugins
			CopyFiles /SILENT $PROGRAMDIRECTORY\*.* $PLUGINSDIR\${NAME}\program
			StrCpy $PROGRAMDIRECTORY $PLUGINSDIR\${NAME}\PLUGINSDIR
			CopyFiles /SILENT $GPGPATHDIRECTORY\*.* $PLUGINSDIR\${NAME}\gpgpath
			StrCpy $GPGPATHDIRECTORY $PLUGINSDIR\${NAME}\gpgpath
			CopyFiles /SILENT $GPGHOMEDIRECTORY\*.* $PLUGINSDIR\${NAME}\gpghome
			StrCpy $GPGHOMEDIRECTORY $PLUGINSDIR\${NAME}\gpghome
			${SetFileAttributesDirectoryNormal} "$PLUGINSDIR\${NAME}"

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
				
		;=== Replace drive letter entries
		${ReplaceInFileCS} "$PROFILEDIRECTORY\prefs.js" `file:///$2` `file:///$3`
		${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" `", "$2:\\` `", "$3:\\`
	
	FixPrefsJsPart2:
		;=== Be sure the default browser check is disabled
		FileOpen $0 "$PROFILEDIRECTORY\prefs.js" a
		FileSeek $0 0 END
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		FileWrite $0 `user_pref("mail.shell.checkDefaultClient", false);`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		FileWrite $0 `user_pref("mail.winsearch.firstRunDone", true);`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		FileWrite $0 `user_pref("mail.winsearch.enable", false);`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		
	;FixPrefsJsClose:
		FileClose $0 

		
	FixOtherFiles:
		StrCmp $LASTPROFILEDIRECTORY "NONE" RunProgram
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last ThunderbirdPortable directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current ThunderbirdPortable directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.ini"
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.ini" $0 $1
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
		StrCmp $ALLOWMULTIPLEINSTANCES "true" StartProgramNow
		StrCmp $SECONDARYLAUNCH "true" StartProgramAndExit
		;=== Check for registry permissions
		UserInfo::GetAccountType
		Pop $0
		StrCpy $USERTYPE $0
		StrCmp $USERTYPE "Guest" StartProgramNow
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		StrCmp $R0 "-1" +3 ;=== If it doesn't exist, skip the next line
			${registry::CopyKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupByThunderbirdPortable" $R0
		Goto +2
			StrCpy $NOUNREADMAILKEY "true"
		StrCmp $USERTYPE "User" StartProgramNow
		${registry::KeyExists} "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird" $R0
		StrCmp $R0 "-1" +3 ;=== If it doesn't exist, skip the next 2 lines
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird" "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird-BackupByThunderbirdPortable" $R0
		Sleep 100
		${registry::Write} "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird\Desktop" "showMapiDialog" "0" "REG_SZ" $R0
		Sleep 100

	StartProgramNow:
		Rename "$APPDATA\Thunderbird\Crash Reports" "$APPDATA\Thunderbird\Crash Reports-BackupByThunderbirdPortable"
		ReadEnvStr $strOriginalTempPath TEMP
		CreateDirectory "$PLUGINSDIR\ContainedTemp"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$PLUGINSDIR\ContainedTemp").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$PLUGINSDIR\ContainedTemp").r0'
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING
		
	;CheckRunning:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" TheEnd
		
	CheckRunning:
		FindProcDLL::WaitProcEnd "thunderbird.exe" -1
		Sleep 2000
		FindProcDLL::FindProc "thunderbird.exe" 
		StrCmp $R0 "1" "" TheEnd		
		IfFileExists "$PROFILEDIRECTORY\parent.lock" CheckRunning TheEnd
	
	StartProgramAndExit:
		ReadEnvStr $strOriginalTempPath TEMP
		CreateDirectory "$PLUGINSDIR\ContainedTemp"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$PLUGINSDIR\ContainedTemp").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$PLUGINSDIR\ContainedTemp").r0'
		SetOutPath $PROGRAMDIRECTORY
		Exec $EXECSTRING
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$strOriginalTempPath").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$strOriginalTempPath").r0'
		Goto TheRealEnd2

	TheEnd:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$strOriginalTempPath").r0'
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TMP", "$strOriginalTempPath").r0'
		
		;=== Restore registry keys
		;StrCmp $USERTYPE "Guest" EndWithoutRegRestore
		;${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupByThunderbirdPortable" $R0
		;StrCmp $R0 "-1" +4 ;=== If it doesn't exist, skip the next 3 lines
		RMDir /r "$PLUGINSDIR\ContainedTemp"
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		Sleep 100
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail-BackupByThunderbirdPortable" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		StrCmp $NOUNREADMAILKEY "true" 0 +2
			${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\UnreadMail" $R0
		StrCmp $USERTYPE "User" EndWithoutRegRestore
		${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird" $R0
		${registry::MoveKey} "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird-BackupByThunderbirdPortable" "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla Thunderbird" $R0

	
	EndWithoutRegRestore:
		StrCmp $DISABLESPLASHSCREEN "true" CleanupRunLocally
			Sleep 2000
			newadvsplash::stop
			RMDir /r "$PLUGINSDIR\ContainedTemp"			

	CleanupRunLocally:
		StrCmp $RUNLOCALLY "true" "" TheRealEnd
		RMDir /r "$PLUGINSDIR\${NAME}\"

	TheRealEnd:
		RMDir "$APPDATA\Mozilla\Extensions" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)
		RMDir /r "$APPDATA\Thunderbird\Crash Reports"
		Rename "$APPDATA\Thunderbird\Crash Reports-BackupByThunderbirdPortable" "$APPDATA\Thunderbird\Crash Reports"
		RMDir "$APPDATA\Thunderbird\Profiles\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Thunderbird\Profile\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\Thunderbird\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\gnupg\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\Extensions\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Mozilla\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Thunderbird\thunderbird\updates\0" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Thunderbird\thunderbird\updates" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Thunderbird\thunderbird" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Thunderbird\" ;=== Will only delete if empty (no /r switch)
		
		${If} ${FileExists} "$GPGPATHDIRECTORY\GPGShutdown.exe"
			ExecWait "$GPGPATHDIRECTORY\GPGShutdown.exe"
		${EndIf}
		
	TheRealEnd2:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd