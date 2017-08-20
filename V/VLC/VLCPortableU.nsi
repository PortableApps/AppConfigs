;Copyright (C) 2004-2017 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/VLCPortable

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

!define PORTABLEAPPNAME "VLC Media Player Portable"
!define APPNAME "VLC"
!define NAME "VLCPortable"
!define VER "1.7.2.0"
!define WEBSITE "PortableApps.com/VLCPortable"
!define DEFAULTEXE "vlc.exe"
!define DEFAULTAPPDIR "vlc"
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
VIAddVersionKey LegalCopyright "John T. Haller"
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
!insertmacro GetParameters
!insertmacro GetRoot
!include LogicLib.nsh

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var DISABLESPLASHSCREEN
Var ISDEFAULTDIRECTORY
Var DRIVEROOT
Var MISSINGFILEORPATH
Var APPLANGUAGE
Var SECONDARYLAUNCH
Var LASTDRIVE
Var CURRENTDRIVE
Var VLCTEMP
Var intCounter

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
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			;=== Read the parameters from the INI file
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\$0"
			${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\$0"
			${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
			${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
			${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

			;=== Check if default directories
			StrCmp $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}" "" EndINI
			StrCmp $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}" "" EndINI
			StrCpy $ISDEFAULTDIRECTORY "true"
	
	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE
	
	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
		StrCpy "$DISABLESPLASHSCREEN" "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" CheckPortableProgramDIR
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
			StrCpy "$ISDEFAULTDIRECTORY" "true"
			GoTo EndINI

		CheckPortableProgramDIR:
			IfFileExists "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
				StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}"
				StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\${NAME}\Data\${DEFAULTSETTINGSDIR}"
				GoTo FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		;Check for settings directory
		IfFileExists "$SETTINGSDIRECTORY\*.*" SettingsDirectoryReady
		StrCmp "$ISDEFAULTDIRECTORY" "true" "" NoSettingsDirectory
		CreateDirectory "$SETTINGSDIRECTORY"
		Goto SettingsDirectoryReady
		
	NoSettingsDirectory:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $SETTINGSDIRECTORY
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
	
	SettingsDirectoryReady:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
		StrCmp $SECONDARYLAUNCH "true" GetPassedParameters
		;=== Show the splash screen before processing the files
		InitPluginsDir
		File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
		
		newadvsplash::show /NOUNLOAD 1300 0 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" --vlm-conf "$SETTINGSDIRECTORY\vlcrc" --no-plugins-cache --config "$SETTINGSDIRECTORY\vlcrc"`
		Goto AdjustSettings

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0 --vlm-conf "$SETTINGSDIRECTORY\vlcrc" --no-plugins-cache --config "$SETTINGSDIRECTORY\vlcrc"`
	
	AdjustSettings:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndClose
		IfFileExists `$SETTINGSDIRECTORY\vlcrc` "" AdjustPaths
			ReadINIStr $0 `$SETTINGSDIRECTORY\vlcrc` "skins2" "skins2-last"
			StrCmp $0 "" AdjustPaths
			${GetRoot} $EXEDIR $DRIVEROOT
			StrCpy $1 $0 "" 2
			StrCpy $0 `$DRIVEROOT$1`
			WriteINIStr `$SETTINGSDIRECTORY\vlcrc` "skins2" "skins2-last" $0

	AdjustPaths:
		${GetRoot} $EXEDIR $CURRENTDRIVE
		ReadINIStr $LASTDRIVE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive"
		ClearErrors
		StrCmp $LASTDRIVE "" RememberPath
		StrCmp $LASTDRIVE $CURRENTDRIVE GetAppLanguage
		IfFileExists "$SETTINGSDIRECTORY\ml.xspf" "" +2
			${ReplaceInFile} "$SETTINGSDIRECTORY\ml.xspf" '<location>file:///$LASTDRIVE/' '<location>file:///$CURRENTDRIVE/'
		IfFileExists "$SETTINGSDIRECTORY\vlcrc" "" +2
			${ReplaceInFile} "$SETTINGSDIRECTORY\vlc-qt-interface.ini" '=$LASTDRIVE\' '=$CURRENTDRIVE\'
		IfFileExists "$SETTINGSDIRECTORY\vlcrc" "" RememberPath
			${ReplaceInFile} "$SETTINGSDIRECTORY\vlcrc" '=$LASTDRIVE\' '=$CURRENTDRIVE\'
	
	RememberPath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "$CURRENTDRIVE"

	GetAppLanguage:
		ReadEnvStr $APPLANGUAGE "PortableApps.comLocaleglibc"
		StrCmp $APPLANGUAGE "" LaunchNow
		ReadINIStr $0 `$SETTINGSDIRECTORY\vlcrc` "main" "language"
		StrCmp $APPLANGUAGE $0 LaunchNow
		StrCmp $APPLANGUAGE "en" SetAppLanguage
		StrCmp $APPLANGUAGE "en_us" SetDefaultLanguage
		IfFileExists "$PROGRAMDIRECTORY\locale\$APPLANGUAGE\*.*" SetAppLanguage LaunchNow
		
	SetDefaultLanguage:
		StrCpy $APPLANGUAGE "en"

	SetAppLanguage:
		WriteINIStr `$SETTINGSDIRECTORY\vlcrc` "main" "language" $APPLANGUAGE
	
	LaunchNow:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndClose
		;=== Backup local VLC files if present
		Rename `$APPDATA\vlc` `$APPDATA\vlc-BackupByVLCPortable`
		Rename `$APPDATA\dvdcss` `$APPDATA\dvdcss-BackupByVLCPortable`
		CreateDirectory `$APPDATA\vlc`
		CopyFiles /SILENT `$SETTINGSDIRECTORY\ml.xspf` `$APPDATA\vlc\`
		CopyFiles /SILENT `$SETTINGSDIRECTORY\vlc-qt-interface.ini` `$APPDATA\vlc\`
		CopyFiles /SILENT `$SETTINGSDIRECTORY\*.cache-3` `$APPDATA\vlc\`
		StrCpy $VLCTEMP "$TEMP\VLCPortableTemp"
		CreateDirectory "$VLCTEMP"
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$VLCTEMP").r0'
		ExecWait $EXECSTRING
		CheckRunning:
			Sleep 1000
			FindProcDLL::FindProc "$PROGRAMEXECUTABLE"                  
			StrCmp $R0 "1" CheckRunning

		CopyFiles /SILENT `$APPDATA\vlc\ml.xspf` `$SETTINGSDIRECTORY\`
		CopyFiles /SILENT `$APPDATA\vlc\vlc-qt-interface.ini` `$SETTINGSDIRECTORY\`
		CopyFiles /SILENT `$APPDATA\vlc\*.cache-3` `$SETTINGSDIRECTORY\`
		RMDir /r `$APPDATA\vlc`
		RMDir /r `$APPDATA\dvdcss`
		${For} $intCounter 0 999
			Delete "$TEMP\vlc$intCounter"
		${Next}
		RMDir /r `$VLCTEMP`
		Rename `$APPDATA\vlc-BackupByVLCPortable` `$APPDATA\vlc`
		Rename `$APPDATA\dvdcss-BackupByVLCPortable` `$APPDATA\dvdcss`
		GoTo TheEnd

	LaunchAndClose:
		Exec $EXECSTRING

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd