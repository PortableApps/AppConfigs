;Copyright 2004-2012 John T. Haller
;Copyright 2010 Michael Secord

;Website: http://PortableApps.com/SongbirdPortable

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

!define PORTABLEAPPNAME "Songbird Portable"
!define APPNAME "Songbird"
!define NAME "SongbirdPortable"
!define VER "1.10.1.0"
!define WEBSITE "PortableApps.com/SongbirdPortable"
!define DEFAULTEXE "songbird.exe"
!define DEFAULTAPPDIR "songbird"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "PortableApps.com and contributors"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "Songbird and related logos are Trademarks of POTI, Inc. PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
;WindowIcon Off
SilentInstall Silent
;AutoCloseWindow True
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!include Registry.nsh
!include TextFunc.nsh
!include LogicLib.nsh
!insertmacro GetRoot
!insertmacro GetParameters

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include ReadINIStrWithDefault.nsh
!include ReplaceInFileWithTextReplace.nsh
!include SetFileAttributesDirectoryNormal.nsh
!include StrStrip.nsh
!include CharToASCII.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh


;=== Variables
Var PROGRAMDIRECTORY
Var SQLITEDIRECTORY
Var PROFILEDIRECTORY
Var SETTINGSDIRECTORY
Var MUSICDIR
Var ADDITIONALPARAMETERS
Var ALLOWMULTIPLEINSTANCES
Var SKIPCOMPREGFIX
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var DISABLEINTELLIGENTSTART
Var ISDEFAULTDIRECTORY
Var RUNLOCALLY
Var LASTPROFILEDIRECTORY
Var LASTDRIVE
Var LASTEXEDIR
Var CURRENTDRIVE
Var SQLQUERY
Var SECONDARYLAUNCH
Var MISSINGFILEORPATH
Var CRASHREPORTSDIREXISTS
Var EXTENSIONSDIREXISTS
Var SBTEMPEXISTS
Var TREEFILE

Section "Main"
	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR"

		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SQLiteDirectory" "App\SQLite"
		StrCpy $SQLITEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "ProfileDirectory" "Data\profile"
		StrCpy $PROFILEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\settings"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"

		;=== Check that the above required parameters are present
		IfErrors NoINI

		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$INIPATH\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"
		${ReadINIStrWithDefault} $SKIPCOMPREGFIX "$INIPATH\${NAME}.ini" "${NAME}" "SkipCompregFix" "false"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $DISABLEINTELLIGENTSTART "$INIPATH\${NAME}.ini" "${NAME}" "DisableIntelligentStart" "false"
		${ReadINIStrWithDefault} $RUNLOCALLY "$INIPATH\${NAME}.ini" "${NAME}" "RunLocally" "false"
		StrCmp $RUNLOCALLY "true" "" CleanUpAnyErrors

	CleanUpAnyErrors:
		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Check if default directories
		StrCmp $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}" "" EndINI
		StrCmp $SQLITEDIRECTORY "$EXEDIR\App\SQLite" "" EndINI
		StrCmp $PROFILEDIRECTORY "$EXEDIR\Data\profile" "" EndINI
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings" "" EndINI
		StrCpy $ISDEFAULTDIRECTORY "true"

	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $ALLOWMULTIPLEINSTANCES "false"
		StrCpy $SKIPCOMPREGFIX "false"
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $DISABLEINTELLIGENTSTART "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $SQLITEDIRECTORY "$EXEDIR\App\SQLite"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\profile"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
			StrCpy $ISDEFAULTDIRECTORY "true"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	FoundProgramEXE:
		IfFileExists "$APPDATA\Songbird2\Crash Reports\*.*" "" CheckIfRunning
			StrCpy $CRASHREPORTSDIREXISTS "true"

	CheckIfRunning:
		;=== Check if running
		StrCmp $ALLOWMULTIPLEINSTANCES "true" ProfileWork
		FindProcDLL::FindProc "songbird.exe"
		StrCmp $R0 "1" "" CheckForCrashReports
			;=== Already running, check if it is using the portable profile
			IfFileExists "$PROFILEDIRECTORY\parent.lock" "" WarnAnotherInstance
				StrCpy $SECONDARYLAUNCH "true"
				Goto RunProgram

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort

	CheckForCrashReports:
		IfFileExists "$APPDATA\Songbird2\Crash Reports\*.*" "" CheckForExtensionsDirectory
		Rename "$APPDATA\Songbird2\Crash Reports" "$APPDATA\Songbird2\Crash Reports-BackupBySongbirdPortable"
		StrCpy $CRASHREPORTSDIREXISTS "true"
		
	CheckForExtensionsDirectory:
		IfFileExists "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com" "" ProfileWork
		Rename "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com" "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com-BackupBySongbirdPortable"
		StrCpy $EXTENSIONSDIREXISTS "true"
                IfFileExists "$TEMP\Songbird" "" ProfileWork
                Rename "$TEMP\Songbird" "$TEMP\Songbird-BackupBySongbirdPortable"
                StrCpy $SBTEMPEXISTS "true"

	ProfileWork:
	;=== Check for an existing profile
	IfFileExists "$PROFILEDIRECTORY\prefs.js" ProfileFound
		;=== No profile was found
		StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultProfile CreateProfile

	CopyDefaultProfile:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\profile"
		CreateDirectory "$EXEDIR\Data\settings"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\profile\*.* $EXEDIR\Data\profile
		GoTo ProfileFound

	CreateProfile:
		IfFileExists "$PROFILEDIRECTORY\*.*" ProfileFound
		CreateDirectory "$PROFILEDIRECTORY"

	ProfileFound:
		IfFileExists "$SETTINGSDIRECTORY\${NAME}Settings.ini" SettingsFound
			CreateDirectory "$SETTINGSDIRECTORY"
			FileOpen $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" w
			FileClose $R0
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" "NONE"

	SettingsFound:
        ;=== Update to new ini
		;=== Read last profile directory
		ReadINIStr $LASTPROFILEDIRECTORY "$SETTINGSDIRECTORY\SongbirdPortableSettings.ini" "SongbirdPortableSettings" "LastProfileDirectory"
		;=== Read last drive letter
		ReadINIStr $LASTDRIVE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDriveLetter"
		;=== Read last ExeDir
		ReadINIStr $LASTEXEDIR "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastExeDir"
          ;=== Remove Old INI
          Delete "$SETTINGSDIRECTORY\${NAME}Settings.ini"

          ;=== Create new INI
          FileOpen $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" w
          FileClose $R0
          WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" $PROFILEDIRECTORY
          ${GetRoot} $EXEDIR $CURRENTDRIVE
          WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDriveLetter" $CURRENTDRIVE
          WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastExeDir" $EXEDIR
		
		;=== Check for read/write
		StrCmp $RUNLOCALLY "true" CheckForRunLocal
		ClearErrors
		FileOpen $R0 "$PROFILEDIRECTORY\writetest.temp" w
		IfErrors "" WriteSuccessful
			;== Write failed, so we're read-only
			MessageBox MB_YESNO|MB_ICONQUESTION `$(LauncherAskCopyLocal)` IDYES SwitchToRunLocally
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherNoReadOnly)`
			Abort

	SwitchToRunLocally:
		StrCpy $RUNLOCALLY "true"
		Goto CheckForRunLocal

	WriteSuccessful:
		FileClose $R0
		Delete "$PROFILEDIRECTORY\writetest.temp"

	CheckForRunLocal:
		;=== Run locally if needed (aka Portable Songbird Live)
		StrCmp $RUNLOCALLY "true" "" CompareProfilePath
		RMDir /r "$TEMP\${NAME}\"
		CreateDirectory $TEMP\${NAME}\profile
		CreateDirectory $TEMP\${NAME}\settings
		CreateDirectory $TEMP\${NAME}\program
		CopyFiles /SILENT $PROFILEDIRECTORY\*.* $TEMP\${NAME}\profile
		StrCpy $PROFILEDIRECTORY $TEMP\${NAME}\profile
		CopyFiles /SILENT $PROGRAMDIRECTORY\*.* $TEMP\${NAME}\program
		StrCpy $PROGRAMDIRECTORY $TEMP\${NAME}\program
		${SetFileAttributesDirectoryNormal} "$TEMP\${NAME}"

	CompareProfilePath:
		StrCmp $PROFILEDIRECTORY $LASTPROFILEDIRECTORY "" AdjustSettings
		StrCmp $LASTEXEDIR $EXEDIR "" AdjustSettings
			StrCmp $DISABLEINTELLIGENTSTART "true" AdjustSettings
				StrCpy $SKIPCOMPREGFIX "true"

	AdjustSettings:
		;=== Extensions.ini correction.
		StrCmp $LASTEXEDIR "" FixDriveLetter
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.ini" "$LASTEXEDIR\" "$EXEDIR\"

     FixDriveLetter:
		${GetRoot} $EXEDIR $CURRENTDRIVE
		StrCmp $LASTDRIVE "" RunProgram
		StrCmp $LASTDRIVE $CURRENTDRIVE RunProgram
		IfFileExists "$PROFILEDIRECTORY\prefs.js" "" CheckMusicExists
		
		;=== Replace drive letter entries in prefs.js
		${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" "$LASTDRIVE\\" "$CURRENTDRIVE\\"
		;=== Replace drive letter in .tree file
   		${ConfigRead} "$PROFILEDIRECTORY\prefs.js" "user_pref($\"songbird.watch_folder.sessionguid$\"," $R2
  		${StrStrip} "$\");" "$R2" $TREEFILE
  		${StrStrip} " $\"" "$TREEFILE" $TREEFILE
  		StrCpy $TREEFILE `$TREEFILE.tree`
  		FileOpen $0 "$PROFILEDIRECTORY\fstrees\$TREEFILE" a
  		FileSeek $0 9 SET
  		FileReadByte $0 $1
  		FileSeek $0 10 SET
  		FileReadByte $0 $7
  		IntFmt $2 "%C" "$1"
  		${StrStrip} ":" $CURRENTDRIVE $3
          ${CharToASCII} $4 $3
          FileSeek $0 9 SET
          FileWriteByte $0 $4

		Goto FixDatabase
		
	CheckMusicExists:
		ReadEnvStr $MUSICDIR "PortableApps.comMusic"

		StrCmp $MUSICDIR "" ManuallyCheckForDocuments
		IfFileExists "$MUSICDIR\*.*" SetDefaultDownloadDir ManuallyCheckForDocuments

		ManuallyCheckForDocuments:
			IfFileExists "$CURRENTDRIVE\Documents\Music\*.*" "" UseRootPath
			StrCpy $MUSICDIR "$CURRENTDRIVE\Documents\Music"
			Goto SetDefaultDownloadDir

		UseRootPath:
			StrCpy $MUSICDIR "$CURRENTDRIVE\"

	SetDefaultDownloadDir:
		CreateDirectory "$SETTINGSDIRECTORY"
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\profile\*.*" "$PROFILEDIRECTORY\"

		;=== Set the download directory before first run
		${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" "<<PortableApps.comMusic>>" "$MUSICDIR"

	FixDatabase:
		IfFileExists "$PROFILEDIRECTORY\db\main@library.songbirdnest.com.db" "" RunProgram
		;=== Fix the Media location
		StrCpy $SQLQUERY "SET content_url = 'file:///$CURRENTDRIVE' || SUBSTR(content_url,11,1024) WHERE content_url LIKE 'file:///$LASTDRIVE%'"

		;=== Replace in the main db
		nsExec::Exec `"$SQLITEDIRECTORY\sqlite3.exe" "$PROFILEDIRECTORY\db\main@library.songbirdnest.com.db" "UPDATE media_items $SQLQUERY; UPDATE library_media_item $SQLQUERY;"`
		;=== Replace the path to the web db
		nsExec::Exec `"$SQLITEDIRECTORY\sqlite3.exe" "$PROFILEDIRECTORY\db\web@library.songbirdnest.com.db" "UPDATE library_media_item $SQLQUERY;"`
		
		;=== Fix the Resource Properties table
		StrCpy $SQLQUERY "SET obj = 'file:///$CURRENTDRIVE' || SUBSTR(obj,11,1024) WHERE obj LIKE 'file:///$LASTDRIVE%'"
		nsExec::Exec `"$SQLITEDIRECTORY\sqlite3.exe" "$PROFILEDIRECTORY\db\main@library.songbirdnest.com.db" "UPDATE resource_properties $SQLQUERY;"`
		StrCpy $SQLQUERY "SET obj_searchable = 'file:///$CURRENTDRIVE' || SUBSTR(obj,11,1024) WHERE obj_searchable LIKE 'file:///$LASTDRIVE%'"
		nsExec::Exec `"$SQLITEDIRECTORY\sqlite3.exe" "$PROFILEDIRECTORY\db\main@library.songbirdnest.com.db" "UPDATE resource_properties $SQLQUERY;"`
		StrCpy $SQLQUERY "SET obj_sortable = 'file:///$CURRENTDRIVE' || SUBSTR(obj,11,1024) WHERE obj_sortable LIKE 'file:///$LASTDRIVE%'"
		nsExec::Exec `"$SQLITEDIRECTORY\sqlite3.exe" "$PROFILEDIRECTORY\db\main@library.songbirdnest.com.db" "UPDATE resource_properties $SQLQUERY;"`

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
		;=== Backup the registry
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\classes\songbird\" $R0
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\classes\songbird" "HKEY_CURRENT_USER\Software\classes\songbird-BackupBy-SongbirdPortable" $R0
		Sleep 100
		;=== Set the plugins directory if we have a path
		StrCmp $PLUGINSDIRECTORY "" LaunchNow
		IfFileExists "$PLUGINSDIRECTORY\*.*" "" LaunchNow
		System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("MOZ_PLUGIN_PATH", "$PLUGINSDIRECTORY").r0'

	LaunchNow:
		StrCmp $SECONDARYLAUNCH "true" StartProgramAndExit
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 2000
		StrCmp $ALLOWMULTIPLEINSTANCES "true" TheEnd
		FindProcDLL::FindProc "songbird.exe"
		StrCmp $R0 "1" CheckRunning CleanupRunLocally

	StartProgramAndExit:
		SetOutPath $PROGRAMDIRECTORY
		Exec $EXECSTRING
		Goto TheEnd

	CleanupRunLocally:
		StrCmp $RUNLOCALLY "true" "" CheckIfRemoveLocalFiles
		RMDir /r "$TEMP\${NAME}\"

	CheckIfRemoveLocalFiles:
		FindProcDLL::FindProc "songbird.exe"
		Pop $R0
		StrCmp $R0 "1" CheckIfRemoveLocalFiles RemoveLocalFiles

	RemoveLocalFiles:
		StrCmp $CRASHREPORTSDIREXISTS "true" "" RemoveLocalFiles2
		RMDir /r "$APPDATA\Songbird2\Crash Reports\"
		Rename "$APPDATA\Songbird2\Crash Reports-BackupBySongbirdPortable" "$APPDATA\Songbird2\Crash Reports"

	RemoveLocalFiles2:
		RMDir /r "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com\"
		Rename "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com-BackupBySongbirdPortable" "$APPDATA\Mozilla\Extensions\songbird@songbirdnest.com"
		RMDir /r "$TEMP\Songbird\"
		Rename "$TEMP\Songbird-BackupBySongbirdPortable" "$TEMP\Songbird"
		RMDir "$LOCALAPPDATA\Songbird2\Profiles\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\Songbird2\" ;=== Will only delete if empty (no /r switch)
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\classes\songbird\" $R0
		Sleep 100
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\classes\songbird-BackupBy-SongbirdPortable" $R0
		StrCmp $R0 "-1" TheEnd
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\classes\songbird-BackupBy-SongbirdPortable" "HKEY_CURRENT_USER\Software\classes\songbird" $R0
		Sleep 100

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd