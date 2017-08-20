;Copyright (C) 2004-2012 John T. Haller of PortableApps.com
;Copyright (C) 2007 Ryan McCue of PortableApps.com
;Copyright (C) 2008-2009 Oliver Krystal of PortableApps.com

;Website: http://PortableApps.com/PNotesPortable

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

!define PORTABLEAPPNAME "PNotes Portable"
!define APPNAME "PNotes"
!define NAME "PNotesPortable"
!define VER "1.8.4.0"
!define WEBSITE "PortableApps.com/PNotesPortable"
!define DEFAULTEXE "PNotes.exe"
!define DEFAULTAPPDIR "PNotes"
!define DEFAULTSETTINGSDIR "settings"
!define LAUNCHERLANGUAGE "english"

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

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico" ;defines the icon for the script

;=== Include
;NSIS
!include FileFunc.nsh
!insertmacro GetParent
!include LogicLib.nsh

;Custom
!include CheckForPlatformSplashDisable.nsh
!include ReadINIStrWithDefault.nsh

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh


Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var DISABLESPLASHSCREEN
Var APPLANGUAGE
Var ADDITIONALPARAMETERS
Var MISSINGFILEORPATH

Section "Main"
	;=== Find the INI file, if there is one
			;=== Read the parameters from the INI file
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
			StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
			StrCpy $ADDITIONALPARAMETERS ""
			StrCpy $DISABLESPLASHSCREEN "false" ;by copying these values now, we insure that they are setup before we check for the ini
												;if we read to them, they are overwritten
			
			IfFileExists $EXEDIR\${NAME}.ini 0 CheckForFile
				${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
				${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

		CheckForFile:
			IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE
			;=== Program executable not where expected
				StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
				MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
				Abort

	FoundProgramEXE:
			;=== Check if running
			FindProcDLL::FindProc "$PROGRAMEXECUTABLE"
			StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

		WarnAnotherInstance:
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
			Abort

	DisplaySplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SetupDefaultSettings
		       ;=== Show the splash screen while handling the PAF end of things
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg

        SetupDefaultSettings:
        IfFileExists "$SETTINGSDIRECTORY\*.*" GetAppLanguage
                CreateDirectory "$EXEDIR\Data\settings"
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\*.*" "$SETTINGSDIRECTORY\"
				WriteINIStr "$SETTINGSDIRECTORY\Notes.ini" "lang" "file" "${LAUNCHERLANGUAGE}.lng" ;Default to what the installer was compiled in.
				GoTo GetAppLanguage

        GetAppLanguage:
                ReadEnvStr $APPLANGUAGE "PortableApps.comLanguageCode"

				  StrCmp $APPLANGUAGE "ar-sa" Arabic
                  StrCmp $APPLANGUAGE "hy" Armenian
				  StrCmp $APPLANGUAGE "bg" Bulgarian
                  StrCmp $APPLANGUAGE "ca" Catalan
                  StrCmp $APPLANGUAGE "zh-cn" ChineseSimplified
                  StrCmp $APPLANGUAGE "zh-tw" ChineseTradtional
                  StrCmp $APPLANGUAGE "cs" Czech
				  StrCmp $APPLANGUAGE "da" Danish
                  StrCmp $APPLANGUAGE "nl" Dutch
                  StrCmp $APPLANGUAGE "en" English
				  StrCmp $APPLANGUAGE "en-gb" English
                  StrCmp $APPLANGUAGE "fi" Finnish
                  StrCmp $APPLANGUAGE "fr" French
                  StrCmp $APPLANGUAGE "de" German
                  StrCmp $APPLANGUAGE "he" Hebrew
				  StrCmp $APPLANGUAGE "el" Greek
				  StrCmp $APPLANGUAGE "hu" Hungarian
                  StrCmp $APPLANGUAGE "it" Italian
				  StrCmp $APPLANGUAGE "ja" Japanese
                  StrCmp $APPLANGUAGE "ko" Korean
                  StrCmp $APPLANGUAGE "lt" Lithuanian
                  StrCmp $APPLANGUAGE "pt-br" PortugueseBrazilian
				  StrCmp $APPLANGUAGE "pt" PortugueseStandard
                  StrCmp $APPLANGUAGE "pl" Polish
                  StrCmp $APPLANGUAGE "ro" Romanian
                  StrCmp $APPLANGUAGE "ru" Russian
                  StrCmp $APPLANGUAGE "sl" Slovenian
                  StrCmp $APPLANGUAGE "es" Spanish
				  StrCmp $APPLANGUAGE "es-mx" SpanishInternational
				  StrCmp $APPLANGUAGE "sv" Swedish
                  StrCmp $APPLANGUAGE "tr" Turkish
                  StrCmp $APPLANGUAGE "uk" Ukrainian
				  StrCmp $APPLANGUAGE "vi" Vietnamese LaunchNow ;If none of the language fits,use whatever is currently in the INI

				  Arabic:
                          StrCpy $APPLANGUAGE "arabic"
                          Goto GetCurrentLanguage
                  Armenian:
                          StrCpy $APPLANGUAGE "armenian"
                          Goto GetCurrentLanguage
				  Bulgarian:
                          StrCpy $APPLANGUAGE "bulgarian"
                          Goto GetCurrentLanguage
                  Catalan:
                          StrCpy $APPLANGUAGE "catalan"
                          Goto GetCurrentLanguage
                  ChineseSimplified:
                          StrCpy $APPLANGUAGE "chinese_smp"
                          Goto GetCurrentLanguage
                  ChineseTradtional:
                          StrCpy $APPLANGUAGE "chinese_tr"
                          Goto GetCurrentLanguage
                  Czech:
                          StrCpy $APPLANGUAGE "czech"
                          Goto GetCurrentLanguage
                  Danish:
                          StrCpy $APPLANGUAGE "danish"
                          Goto GetCurrentLanguage
				  Dutch:
                          StrCpy $APPLANGUAGE "dutch"
                          Goto GetCurrentLanguage
                  English:
                          StrCpy $APPLANGUAGE "english"
                          Goto GetCurrentLanguage
                  Finnish:
                          StrCpy $APPLANGUAGE "finnish"
                          Goto GetCurrentLanguage
                  French:
                          StrCpy $APPLANGUAGE "french"
                          Goto GetCurrentLanguage
                  German:
                          StrCpy $APPLANGUAGE "german"
                          Goto GetCurrentLanguage
                  Hebrew:
                          StrCpy $APPLANGUAGE "hebrew"
                          Goto GetCurrentLanguage
				  Greek:
                          StrCpy $APPLANGUAGE "greek"
                          Goto GetCurrentLanguage
				  Hungarian:
                          StrCpy $APPLANGUAGE "hungarian"
                          Goto GetCurrentLanguage
                  Italian:
                          StrCpy $APPLANGUAGE "italian"
                          Goto GetCurrentLanguage
			      Japanese:
                          StrCpy $APPLANGUAGE "japanese"
                          Goto GetCurrentLanguage
                  Korean:
                          StrCpy $APPLANGUAGE "korean"
                          Goto GetCurrentLanguage
                  Lithuanian:
                          StrCpy $APPLANGUAGE "lithuanian"
                          Goto GetCurrentLanguage
			      PortugueseBrazilian:
                          StrCpy $APPLANGUAGE "portuguese_br"
                          Goto GetCurrentLanguage
                  PortugueseStandard:
                          StrCpy $APPLANGUAGE "portuguese_st"
                          Goto GetCurrentLanguage
                  Polish:
                          StrCpy $APPLANGUAGE "polish"
                          Goto GetCurrentLanguage
                  Romanian:
                          StrCpy $APPLANGUAGE "romanian"
                          Goto GetCurrentLanguage
                  Russian:
                          StrCpy $APPLANGUAGE "russian"
                          Goto GetCurrentLanguage
                  Slovenian:
                          StrCpy $APPLANGUAGE "slovenian"
                          Goto GetCurrentLanguage
                  Spanish:
                          StrCpy $APPLANGUAGE "spanish"
                          Goto GetCurrentLanguage
				  SpanishInternational:
                          StrCpy $APPLANGUAGE "spanish"
                          Goto GetCurrentLanguage
				  Swedish:
                          StrCpy $APPLANGUAGE "swedish"
                          Goto GetCurrentLanguage
                  Turkish:
                          StrCpy $APPLANGUAGE "turkish"
                          Goto GetCurrentLanguage
                  Ukrainian:
                          StrCpy $APPLANGUAGE "ukrainian"
                          Goto GetCurrentLanguage
				  Vietnamese:
                          StrCpy $APPLANGUAGE "vietnamese"
                          Goto GetCurrentLanguage


        GetCurrentLanguage:
                ReadINIStr $0 "$SETTINGSDIRECTORY\Notes.ini" "lang" "file"
                StrCmp "$APPLANGUAGE.lng" $0 LaunchNow ;if the same, move on
                IfFileExists "$PROGRAMDIRECTORY\lang\$APPLANGUAGE.lng" SetAppLanguage LaunchNow

        SetAppLanguage:
                WriteINIStr "$SETTINGSDIRECTORY\Notes.ini" "lang" "file" "$APPLANGUAGE.lng"

        LaunchNow:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" "$ADDITIONALPARAMETERS" -conf "$SETTINGSDIRECTORY" "$SETTINGSDIRECTORY" "$EXEDIR\${NAME}.exe" "$SETTINGSDIRECTORY" "$PROGRAMDIRECTORY\skins" "$SETTINGSDIRECTORY\backup"`
                Exec $EXECSTRING
                Sleep 1200 ;=== allow the splash screen to show for at least 2 seconds after starting
                newadvsplash::stop /WAIT
SectionEnd
