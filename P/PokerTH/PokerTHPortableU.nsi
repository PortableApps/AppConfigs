;Copyright (C) 2004-2012 John T. Haller

;Website: http://PortableApps.com/PokerTHPortable

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

!define PORTABLEAPPNAME "PokerTH Portable"
!define NAME "PokerTHPortable"
!define APPNAME "PokerTH"
!define VER "1.6.4.0"
!define WEBSITE "PortableApps.com/PokerTHPortable"
!define DEFAULTEXE "PokerTH.exe"
!define DEFAULTAPPDIR "pokerth"
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
CRCCheck on
XPStyle on
WindowIcon off
SilentInstall silent
AutoCloseWindow true
RequestExecutionLevel user

; Best Compression
SetCompress auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize on

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters ;Requires NSIS 2.40 or better
!insertmacro GetRoot
!include TextFunc.nsh
!insertmacro ConfigRead
!insertmacro ConfigWrite

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh


Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var WAITFORPROGRAM
Var PROGRAMEXECUTABLE
Var ISDEFAULTDIRECTORY
Var DRIVEROOT
Var MISSINGFILEORPATH
Var APPLANGUAGE


Section "Main"
	;=== Find the INI file, if there is one
	IfFileExists "$EXEDIR\${NAME}.ini" ReadINI NoINI

	ReadINI:
		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$EXEDIR\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSDIR}"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		StrCpy $WAITFORPROGRAM "true"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$EXEDIR\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		Goto EndINI

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $WAITFORPROGRAM "true"
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
		StrCpy $ISDEFAULTDIRECTORY "true"

	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	;NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		IfFileExists "$SETTINGSDIRECTORY\pokerth\config.xml" SettingsFound
			;=== No profile was found
			StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultSettings
			StrCpy $MISSINGFILEORPATH $SETTINGSDIRECTORY
			MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
			Abort
	
	CopyDefaultSettings:
		CreateDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
		CreateDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}\pokerth"
		CreateDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}\pokerth\log-files\"
		CreateDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}\pokerth\data\"
		CreateDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}\pokerth\cache\"
		StrCmp "$ISDEFAULTDIRECTORY" "true" "" SettingsFound
			CopyFiles "$EXEDIR\App\DefaultData\settings\pokerth\config.xml" "$EXEDIR\Data\${DEFAULTSETTINGSDIR}\pokerth"


	SettingsFound:
		IfFileExists "$SETTINGSDIRECTORY\pokerth\config.xml" "" GetPassedParameters			
			;GetAppLanguage:
				ReadEnvStr $APPLANGUAGE "PortableApps.comLanguageCode"
				StrCmp $APPLANGUAGE "" AdjustDataDir ;if not set, move on
				
				StrCmp $APPLANGUAGE "pt-br" "" CheckForPortuguese
					StrCpy $APPLANGUAGE "ptbr"
					Goto CompareAppLanguageToCurrent
					
				CheckForPortuguese:
					StrCmp $APPLANGUAGE "pt" "" CheckForChinese
						StrCpy $APPLANGUAGE "ptpt"
						Goto CompareAppLanguageToCurrent

				CheckForChinese:
					StrCmp $APPLANGUAGE "zh" "" CheckForCzech
						StrCpy $APPLANGUAGE "zhcn"
						Goto CompareAppLanguageToCurrent
						
				CheckForCzech:
					StrCmp $APPLANGUAGE "cs" "" ShortenAppLanguageString
						StrCpy $APPLANGUAGE "cz"
						Goto CompareAppLanguageToCurrent
				
				ShortenAppLanguageString:
					StrCpy $APPLANGUAGE $APPLANGUAGE 2
				
			CompareAppLanguageToCurrent:
				${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Language value="` $0
				StrCpy $1 $0 -4 ;remove last 4 chars
				StrCmp `$APPLANGUAGE` $1 AdjustDataDir ;if the same, move on
				StrCmp $APPLANGUAGE "en" WriteAppLanguageToConfig ;english is the default and not an individual file, just set it
				
			;CheckForLangFile:
				IfFileExists "$PROGRAMDIRECTORY\data\translations\pokerth_$APPLANGUAGE.qm" WriteAppLanguageToConfig AdjustDataDir
	
			WriteAppLanguageToConfig:
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Language value="` `$APPLANGUAGE" />` $R0
			
			AdjustDataDir:
			${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <UserDataDir value="` `$SETTINGSDIRECTORY\pokerth\data\" />` $R0
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <AppDataDir value="` $0
			StrCmp $0 "" OldDataDir
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <AppDataDir value="` `$SETTINGSDIRECTORY\pokerth\data\" />` $R0
				Goto AdjustMyAvatar

			OldDataDir:
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <DataDir value="` `$SETTINGSDIRECTORY\pokerth\data\" />` $R0
				Goto AdjustMyAvatar				

			AdjustMyAvatar:
			${GetRoot} $EXEDIR $DRIVEROOT
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <LogDir value="` $0
			StrCmp $0 "" AdjustConfigFile ""
			StrCpy $1 $0 2 ;get drive letter only
			StrCmp $1 $DRIVEROOT AdjustConfigFile ""
				${ReplaceInFile} `$SETTINGSDIRECTORY\pokerth\config.xml` `="$1` `="$DRIVEROOT`
			
		AdjustConfigFile:	
			${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <LogDir value="` `$SETTINGSDIRECTORY\pokerth\log-files\" />` $R0
			${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <CacheDir value="` `$SETTINGSDIRECTORY\pokerth\cache\" />` $R0
			
			
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <MyAvatar value="` $0
			StrCmp $0 `" />` AdjustAvatar1
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar1
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <MyAvatar value="` `$0` $R0
		AdjustAvatar1:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent1Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar2
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar2
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent1Avatar value="` `$0` $R0
		AdjustAvatar2:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent2Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar3
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar3
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent2Avatar value="` `$0` $R0
		AdjustAvatar3:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent3Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar4
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar4
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent3Avatar value="` `$0` $R0
		AdjustAvatar4:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent4Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar5
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar5
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent4Avatar value="` `$0` $R0
		AdjustAvatar5:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent5Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar6
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar6
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent5Avatar value="` `$0` $R0
		AdjustAvatar6:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent6Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar7
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar7
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent6Avatar value="` `$0` $R0
		AdjustAvatar7:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent7Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar8
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar8
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent7Avatar value="` `$0` $R0
		AdjustAvatar8:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent8Avatar value="` $0
			StrCmp $0 `" />` AdjustAvatar9
				StrCpy $1 $0 1
				StrCmp $1 ":" AdjustAvatar9
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent8Avatar value="` `$0` $R0
		AdjustAvatar9:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent9Avatar value="` $0
			StrCmp $0 `" />` FlipSideFile
				StrCpy $1 $0 1
				StrCmp $1 ":" FlipSideFile
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <Opponent9Avatar value="` `$0` $R0
		FlipSideFile:
			${ConfigRead} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <FlipsideOwnFile value="` $0
			StrCmp $0 `" />` GetPassedParameters
				StrCpy $1 $0 1
				StrCmp $1 ":" GetPassedParameters
				StrCpy $1 $0 "" 2
				StrCpy $0 `$DRIVEROOT$1`
				${ConfigWrite} `$SETTINGSDIRECTORY\pokerth\config.xml` `        <FlipsideOwnFile value="` `$0` $R0
	
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
		StrCmp $ADDITIONALPARAMETERS "" UserProfileEnvironment

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	UserProfileEnvironment:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("APPDATA", "$SETTINGSDIRECTORY").r0'

	;LaunchNow:
		StrCmp $WAITFORPROGRAM "true" LaunchAndWait LaunchAndClose

	LaunchAndWait:
		ExecWait $EXECSTRING
		Delete "$TEMP\qtsingleapp-pokert-*-lockfile"
		Goto TheEnd

	LaunchAndClose:
		Exec $EXECSTRING
		Delete "$TEMP\qtsingleapp-pokert-*-lockfile"

	TheEnd:
SectionEnd