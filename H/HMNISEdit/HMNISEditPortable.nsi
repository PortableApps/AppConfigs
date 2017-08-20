;Copyright (C) 2004-2012 John T. Haller
;Copyright (C) 2009-2011 Taffin Foxcroft
;Copyright (C) 2012 PortableApps.com (John T. Haller, Taffin Foxcroft, Gord Caswell)

;Website: http://portableapps.com/HMNISEditPortable

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

!define PORTABLEAPPNAME "HM NIS Edit Portable"
!define APPNAME "HMNISEdit"
!define NAME "HMNISEditPortable"
!define VER "1.5.5.1"
!define WEBSITE "PortableApps.com/HMNISEditPortable"
!define DEFAULTEXE "nisedit.exe"
!define DEFAULTAPPDIR "NISEdit"
!define LAUNCHERLANGUAGE "English"


;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "PortableApps.com"
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
!include "FileFunc.nsh"
!insertmacro GetParameters
!insertmacro GetRoot

;=== custom functions
!include "ReadINIStrWithDefault.nsh"
!include "TextReplace.nsh"
!include "ReplaceInFileWithTextReplace.nsh"
!include "CheckForPlatformSplashDisable.nsh"


;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== import language ===

!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PortableAppsDirectory
Var NSISDIRECTORY
Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var PROGRAMEXECUTABLE
Var ADDITIONALPARAMETERS
Var DISABLESPLASHSCREEN
Var CURRENTDRIVE
Var EXECSTRING
Var INIPATH
Var LASTDRIVE
Var MISSINGFILEORPATH
Var APPLANGUAGE

Section "Main"
	;Set needed directories
	${GetParent} $EXEDIR $PortableAppsDirectory
	StrCpy "$NSISDIRECTORY" "$PortableAppsDirectory\NSISPortable\App\NSIS"
	StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
	StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
	StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"

	;CheckINI:
		StrCpy "$INIPATH" "$EXEDIR"
		Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "" "DisableSplashScreen" "false"

		${GetRoot} $EXEDIR $CURRENTDRIVE
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		;=== Check if running
	;	StrCmp $SECONDARYLAUNCH "true" GetPassedParameters
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
		StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	DisplaySplash:
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
		IfFileExists "$SETTINGSDIRECTORY\*.*" CheckForSettings
			CreateDirectory $SETTINGSDIRECTORY
	
	CheckForSettings:
		; StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		IfFileExists "$SETTINGSDIRECTORY\nisedit.ini" AdjustPaths
                IfFileExists "$PROGRAMDIRECTORY\nisedit.ini" "" CopyDefaultData
					Rename "$PROGRAMDIRECTORY\nisedit.ini" "$SETTINGSDIRECTORY\nisedit.ini"
					Goto AdjustPaths
	
	CopyDefaultData:
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\*.*" "$SETTINGSDIRECTORY\"
		Goto AdjustPaths
                     
		
    AdjustPaths:
		${ReadINIStrWithDefault} $LASTDRIVE "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "H:"
		
		WriteINIStr "$SETTINGSDIRECTORY\nisedit.ini" "Profiles\Default" "Compiler" "$NSISDIRECTORY\makensis.exe"
		WriteINIStr "$SETTINGSDIRECTORY\nisedit.ini" "Profiles\Default" "HelpFile" "$NSISDIRECTORY\NSIS.chm"

		StrCmp $LASTDRIVE $CURRENTDRIVE StoreCurrentDriveLetter
		IfFileExists "$SETTINGSDIRECTORY\nisedit.ini" UpdateSettings StoreCurrentDriveLetter
		
	UpdateSettings:
		${ReplaceInFile} "$SETTINGSDIRECTORY\nisedit.ini" '$LASTDRIVE\' '$CURRENTDRIVE\'
		Goto StoreCurrentDriveLetter

	StoreCurrentDriveLetter:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "$CURRENTDRIVE"
		Goto GetAppLanguage
				
	GetAppLanguage:
			ReadEnvStr $APPLANGUAGE "PortableApps.comLanguageCode"
				StrCmp $APPLANGUAGE "cs" Czech
				StrCmp $APPLANGUAGE "zh" Chinese
				StrCmp $APPLANGUAGE "fi" Finnish
				StrCmp $APPLANGUAGE "fr" French
				StrCmp $APPLANGUAGE "el" Greek
				StrCmp $APPLANGUAGE "hu" Hungarian
				StrCmp $APPLANGUAGE "ko" Korean
				StrCmp $APPLANGUAGE "pt-br" Porteguese
				StrCmp $APPLANGUAGE "uk" Ukrainian
				StrCmp $APPLANGUAGE "de" German
				StrCmp $APPLANGUAGE "en-us" English
				StrCmp $APPLANGUAGE "es-la" Spanish
				StrCmp $APPLANGUAGE "it" Italiano
				StrCmp $APPLANGUAGE "jp" Japanese
				StrCmp $APPLANGUAGE "pl" Polski
				StrCmp $APPLANGUAGE "pt" Porteguese
				StrCmp $APPLANGUAGE "ru" Russian MoveSettings
			  Czech:
					  StrCpy $APPLANGUAGE "czech"
					  Goto GetCurrentLanguage
			  Chinese:
					  StrCpy $APPLANGUAGE "Chinese_Simplified"
					  Goto GetCurrentLanguage
			  Finnish:
					  StrCpy $APPLANGUAGE "finnish"
					  Goto GetCurrentLanguage
			  French:
					  StrCpy $APPLANGUAGE "french"
					  Goto GetCurrentLanguage
			  Greek:
					  StrCpy $APPLANGUAGE "greek"
					  Goto GetCurrentLanguage
			  Hungarian:
					  StrCpy $APPLANGUAGE "hungarian"
					  Goto GetCurrentLanguage
			  Korean:
					  StrCpy $APPLANGUAGE "korean"
					  Goto GetCurrentLanguage
			  Porteguese:
					  StrCpy $APPLANGUAGE "Portuguese_Brazil"
					  Goto GetCurrentLanguage
			  Ukrainian:
					  StrCpy $APPLANGUAGE "ukrainian"
					  Goto GetCurrentLanguage
			  German:
					  StrCpy $APPLANGUAGE "german"
					  Goto GetCurrentLanguage
			  English:
					  StrCpy $APPLANGUAGE "english"
					  Goto GetCurrentLanguage
			  Spanish:
					  StrCpy $APPLANGUAGE "Español"
					  Goto GetCurrentLanguage
			  Italiano:
					  StrCpy $APPLANGUAGE "italiano"
					  Goto GetCurrentLanguage
			  Japanese:
					  StrCpy $APPLANGUAGE "japanese"
					  Goto GetCurrentLanguage
			  Polski:
					  StrCpy $APPLANGUAGE "polski"
					  Goto GetCurrentLanguage
			  Russian:
					  StrCpy $APPLANGUAGE "russian"
					  Goto GetCurrentLanguage

	GetCurrentLanguage:
			ReadINIStr "$0" "$SETTINGSDIRECTORY\nisedit.ini" "Options" "Language"
			StrCmp "$APPLANGUAGE" "$0" MoveSettings ;if the same, move on
			IfFileExists "$PROGRAMDIRECTORY\Lang\$APPLANGUAGE.lng" SetAppLanguage MoveSettings

	SetAppLanguage:
			WriteINIStr "$SETTINGSDIRECTORY\nisedit.ini" "Options" "Language" "$APPLANGUAGE"
			Goto MoveSettings
		
	MoveSettings:
		Rename "$SETTINGSDIRECTORY\nisedit.ini" "$PROGRAMDIRECTORY\nisedit.ini"
    	Goto Launch
			
	Launch:
        ExecWait $EXECSTRING
       	
	;=== Put the settings file back
	Sleep 150
	Rename "$PROGRAMDIRECTORY\nisedit.ini" "$SETTINGSDIRECTORY\nisedit.ini"
	Goto TheEnd
        
	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd