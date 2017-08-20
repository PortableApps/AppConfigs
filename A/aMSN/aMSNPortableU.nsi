;Copyright (C) 2004-2012 John T. Haller of PortableApps.com

;Website: http://portableapps.com/aMSNPortable

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

!define PORTABLEAPPNAME "aMSN Portable"
!define APPNAME "aMSN"
!define NAME "aMSNPortable"
!define VER "1.7.0.0"
!define WEBSITE "PortableApps.com/aMSNPortable"
!define DEFAULTEXE "aMSN.exe"
!define DEFAULTAPPDIR "aMSN"
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

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
;!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
;!insertmacro MUI_LANGUAGE "${LAUNCHERLANGUAGE}"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var DISABLESPLASHSCREEN
Var LASTDRIVE
Var CURRENTDRIVE
Var MISSINGFILEORPATH

Section "Main"
	;CheckINI:
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			;=== Read the parameters from the INI file
			${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
			${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
			Goto EndINI

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
			GoTo EndINI

	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			;=== Show the splash screen while processing registry entries
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg
	
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" SettingsDirectory

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	SettingsDirectory:
		;=== Set the settings directory if we have a path
		IfFileExists "$SETTINGSDIRECTORY\amsn\config.xml" AdjustPaths
			CreateDirectory $SETTINGSDIRECTORY
			CopyFiles /SILENT `$EXEDIR\App\DefaultData\settings\*.*` $SETTINGSDIRECTORY
	
	AdjustPaths:
		ReadINIStr $LASTDRIVE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive"
		${GetRoot} $EXEDIR $CURRENTDRIVE
		StrCmp $LASTDRIVE $CURRENTDRIVE RememberPath
		IfFileExists "$SETTINGSDIRECTORY\amsn\config.xml" "" UpdateGConfig
			${ReplaceInFile} "$SETTINGSDIRECTORY\amsn\config.xml" '>$LASTDRIVE/' '>$CURRENTDRIVE/'
			Delete "$SETTINGSDIRECTORY\amsn\config.xml"
			
	UpdateGConfig:
		IfFileExists "$SETTINGSDIRECTORY\amsn\gconfig.xml" "" UpdateConfigFiles
			${ReplaceInFile} "$SETTINGSDIRECTORY\amsn\gconfig.xml" '>$LASTDRIVE/' '>$CURRENTDRIVE/'
			
	UpdateConfigFiles:
		FindFirst $0 $1 "$SETTINGSDIRECTORY\amsn\*.*"
		UpdateConfigFilesLoop:
			StrCmp $1 "" UpdateConfigFilesLoopDone
			StrCmp $1 "." UpdateConfigFilesNext
			StrCmp $1 ".." UpdateConfigFilesNext
			IfFileExists "$SETTINGSDIRECTORY\amsn\$1\config.xml" 0 UpdateConfigFilesNext
				${ReplaceInFile} "$SETTINGSDIRECTORY\amsn\$1\config.xml" '>$LASTDRIVE/' '>$CURRENTDRIVE/'
			UpdateConfigFilesNext:
			FindNext $0 $1
			Goto UpdateConfigFilesLoop
		UpdateConfigFilesLoopDone:
		FindClose $0
		
	RememberPath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "$CURRENTDRIVE"
		
	;GetCurrentLanguage:
		${ReadINIStrWithDefault} $0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastLanguage" "en"
		ReadEnvStr $1 "PortableApps.comLocaleglibc"
		StrCmp $1 'zh_CN' "" +2
			StrCpy $1 'zh-CN'
		StrCmp $1 'zh_TW' "" +2
			StrCpy $1 'zh-TW'
		StrCmp $1 "" LaunchNow ;If no env var, skip it
		StrCmp $0 $1 LaunchNow ;If the same, skip it
		StrCmp $1 "en" ReplaceLanguageCode
		IfFileExists `$PROGRAMDIRECTORY\scripts\lang\lang$1` ReplaceLanguageCode LaunchNow
		
			ReplaceLanguageCode:
			${ReplaceInFile} "$SETTINGSDIRECTORY\amsn\gconfig.xml" '<value>$0</value>' '<value>$1</value>'
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastLanguage" "$1"	

	LaunchNow:
		SetOutPath `$PROGRAMDIRECTORY`
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("AMSNPORTABLEDATA", "$SETTINGSDIRECTORY").r0'
		Exec $EXECSTRING

	;TheEnd:
		newadvsplash::stop /WAIT
SectionEnd