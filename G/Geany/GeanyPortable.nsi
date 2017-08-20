;Copyright (C) 2004-2017 John T. Haller
;Copyright (C) 2007-2011 Oliver Krystal
;Copyright (C) 2007-2008 Patrick Patience
;This app utilizes some of Erik Pilsits code for implementation of portable fonts.  Applicable copyrights apply. See http://portableapps.com/node/16003 for more information

;Primary Website: http://geanyportable.org
;PortableApps.com Page: http://PortableApps.com/GeanyPortable

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

!define NAME "GeanyPortable"
!define PORTABLEAPPNAME "Geany Portable"
!define APPNAME "Geany"
!define VER "1.9.3.0" ;increment for official release
!define WEBSITE "PortableApps.com/GeanyPortable"
!define DEFAULTEXE "Geany.exe"
!define DEFAULTAPPDIR "Geany\bin"
!define DEFAULTGTKDIR "Geany"
!define DEFAULTSETTINGSDIR "settings"
!define LAUNCHERLANGUAGE "English"
!define LibGTKDLLCheck "libgtk-win32-2.0-0.dll"

!define WM_FONTCHANGE 0x001D ;for portable fonts
!define HWND_BROADCAST 0xFFFF ;for portable fonts

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "OliverK"
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
!insertmacro GetParent
!insertmacro GetRoot
!insertmacro GetParameters ;Requires NSIS 2.40 or better

;(NSIS Plugins)
!include TextReplace.nsh
!include StrRep.nsh
!include LogicLib.nsh ;portable fonts

;(Custom)
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh
!include ProcFunc.nsh
!insertmacro GetProcessPath

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
;!define MUI_ICON "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var ProgramDirectory
Var ProgramExecutable
Var SettingsDirectory
Var FontDirectory
Var UseFonts
Var AdditionalParameters
Var ExecString
Var GTKDirectory
Var MISSINGFILEORPATH
Var ExistsFileChooser
Var ExistsXBEL
Var GTKBookmarks
Var USERPROFILE
Var AppLanguage
Var PathAdditions
Var LastDrive
Var CurrentDrive
Var DisableSplashScreen
Var LaunchAndExit
Var EnchantExisted

Section "Main"
		;=== Read the parameters from the INI file
		StrCpy $ProgramDirectory "$EXEDIR\App\${DEFAULTAPPDIR}"
		StrCpy $SettingsDirectory "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
		StrCpy $ProgramExecutable "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $AdditionalParameters "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $DisableSplashScreen "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		${ReadINIStrWithDefault} $AppLanguage "$EXEDIR\${NAME}.ini" "${NAME}" "ApplicationLanguage" ""
		${ReadINIStrWithDefault} $PathAdditions "$EXEDIR\${NAME}.ini" "${NAME}" "PathAdditions" ""
		${ReadINIStrWithDefault} $UseFonts "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalFonts" "false"
		
		;===CheckCurrentRunning
		${GetProcessPath} "$ProgramExecutable" $0 ;GetProcessPath will return a 0 if the process doesn't exist
			StrCpy $LaunchAndExit 'false'
			StrCmp $0 0 PrepareGTK ;Process does not exist currently, proceed on course, good day 
				StrCpy $LaunchAndExit 'true' ;process does exist and it may be ours.
			StrCmp $0 "$ProgramDirectory\$ProgramExecutable" PrepareGTK
				;Process does exist, and is ours, so launch Geany with whatever
				;the current Geany isn't ours and we should quit while ahead
				;===Warn Another Instance
				MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
				Abort

;General GTK Stuff.  Yes, 'Legacy' Common File support is implemented, though I don't know how far you'd get.
	PrepareGTK:
	;=== CheckGTKDirectory:
		IfFileExists "$EXEDIR\App\${DEFAULTGTKDIR}\bin\${LibGTKDLLCheck}" "" CommonFiles
			StrCpy $GTKDirectory "$EXEDIR\App\${DEFAULTGTKDIR}"
			Goto CheckForFile

	CommonFiles:
		${GetParent} "$EXEDIR" $0
		IfFileExists "$0\CommonFiles\GTK\bin\*.*" "" GTKNotFound
		StrCpy $GTKDirectory "$0\CommonFiles\GTK\"
		Goto CheckForFile
					
	GTKNotFound:
		StrCpy $MISSINGFILEORPATH $GTKDirectory
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort	
		
	CheckForFile:
		;CheckForEXE, see if its existant
		IfFileExists "$ProgramDirectory\$ProgramExecutable" DisplaySplash NoProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $ProgramExecutable
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	DisplaySplash:
		;===Display the splash screen
		StrCmp $LaunchAndExit "true" PathAdditions
		StrCmp $DisableSplashScreen "true" SkipSplashScreen
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"		
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg

	SkipSplashScreen:
		IfFileExists "$SettingsDirectory\*.*" PathAdditions
        CreateDirectory "$EXEDIR\Data\settings"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $SettingsDirectory

	PathAdditions:
	;Setup GTK and handleCheck to see if we have any path additions to work out for Geany
		StrCpy $0 "" ;Empty the $0 variable so no junk is be inadvertantly copyed at the GTK: heading
		StrCmp $PathAdditions "" SetupPath
		${GetRoot} $EXEDIR $0
		${StrReplace} '$0' '@Drive' '$0' '$PathAdditions'

	SetupPath:
		ReadEnvStr $1 "PATH"
		StrCpy $0 "$GTKDirectory\bin;$ProgramDirectory;$0;$1"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PATH", "$0").r0'
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("GTK_BASEPATH", "$GTKDirectory").r0'
	
	;===Add fonts if requested:
	;Code Courtesy wraithdu\ErikPilsits
	StrCmp $LaunchAndExit 'true' LanguageSwitch ;Launch and exit, the Geany fonts has been set up, and we shouldn't do this twice, thrice, etc.
	StrCmp $UseFonts "false" AdjustSettings
			StrCpy $FontDirectory "$EXEDIR\Data\fonts"
			; loop through fonts and add or remove
			FindFirst $0 $1 "$FontDirectory\*.*"
			${DoWhile} $1 != ""
				${If} $1 != "."
				${AndIf} $1 != ".."
					System::Call "gdi32::AddFontResource(t'$FontDirectory\$1')i .r2"
					;${IfThen} $2 = 0 ${|} MessageBox MB_OK|MB_ICONEXCLAMATION "Geany Portable cannot install font <$1>" ${|}
				${EndIf}
				FindNext $0 $1
			${Loop}
			FindClose $0
			; broadcast font change
			SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=1
		
	AdjustSettings:
		;===Handle GTKRC
		Rename "$SettingsDirectory\gtkrc" "$GTKDirectory\etc\gtk-2.0\gtkrc"
		;===Figure out what Drive we are on, and what we were on
		${GetRoot} $EXEDIR $CurrentDrive
		ReadINIStr $LastDrive "$SettingsDirectory\${NAME}Settings.ini" "${NAME}Settings" "LastDriveLetter"
		StrCmp $LastDrive "" StoreCurrentDriveLetter
		StrCmp $LastDrive $CurrentDrive CheckForUserProfileFolders
		;===Fix geany.conf
		${ReplaceInFile} "$SettingsDirectory\geany.conf" "$LastDrive\" "$CurrentDrive\"
		Delete "$SettingsDirectory\geany.conf.old"
		;===Fix spellchecker configuration
		IfFileExists "$SettingsDirectory\plugins\spellcheck\spellcheck.conf" 0 StoreCurrentDriveLetter
		${ReplaceInFile} "$SettingsDirectory\plugins\spellcheck\spellcheck.conf" "$LastDrive\" "$CurrentDrive\"
		Delete "$SettingsDirectory\plugins\spellcheck\spellcheck.conf.old"
	
	StoreCurrentDriveLetter:
		WriteINIStr "$SettingsDirectory\${NAME}Settings.ini" "${NAME}Settings" "LastDriveLetter" "$CurrentDrive"			
		
	CheckForUserProfileFolders:	
		ReadEnvStr $USERPROFILE "USERPROFILE"
		IfFileExists "$USERPROFILE\.recently-used.xbel" 0 +2 ;The number means how many lines to skip
			StrCpy $ExistsXBEL "true"
		IfFileExists "$USERPROFILE\.gtk-bookmarks" 0 +2 ;See above :p
			StrCpy $GTKBookmarks "true"
		IfFileExists "$APPDATA\gtk-2.0\gtkfilechooser.ini" 0 +2
			StrCpy $ExistsFileChooser "true"
		;===Handle the enchant folder bug without using a goto, which is bad coding style
		StrCpy $EnchantExisted "false"
		IfFileExists "$APPDATA\enchant\*.*" 0 LanguageSwitch
		;Okay, so this is a issue I found.  It only exists when using the spellcheck plugin.  The method to fix this is the same as the GTK stuff, but maybe with some extra love
			StrCpy $EnchantExisted "True" ;could set to any other value . . . 
			Rename "$APPDATA\enchant" "$APPDATA\enchant-backup-by-Geany-Portable"			

	LanguageSwitch:
		StrCmp $AppLanguage "" 0 +3 ;read initially up at the begining.  If you didn't put anything it, its empty and will skip setting with that
		ReadEnvStr $AppLanguage "PortableApps.comLocaleglibc" ;read langauge code broadcasted by menu  If its set, we skip this line, so its just set to whatever the ini says
		StrCmp $AppLanguage "" +2 ;Thanks to Bart.S from the PortableApps.com for this patch.
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("LANG", "$AppLanguage").r0' ;set the language for geany to use.  Look it up in the help :D
		

	;=== Get any passed parameters
		${GetParameters} $0
			;MessageBox MB_OK 'Passed Parameters: $0'
		StrCmp "'$0'" "''" "" LaunchProgramParameters

	;=== No parameters
	;I've left some debug messages in for this release.  They'll leave when I've gotten everything to work 
	;properly with multiple launches I'll delete them
		StrCpy $ExecString '"$ProgramDirectory\$ProgramExecutable" -c "$SettingsDirectory"'
						;MessageBox MB_OK '$ExecString'
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $ExecString '"$ProgramDirectory\$ProgramExecutable" $0 -c "$SettingsDirectory"'
		;MessageBox MB_OK '$ExecString | With Params'

	AdditionalParameters:
		StrCmp $AdditionalParameters "" Launch
		StrCpy $ExecString '"$ExecString" "$AdditionalParameters"'
		;MessageBox MB_OK '$ExecString | With Addtional'
		
	Launch: 
		;MessageBox MB_OK '$LaunchAndExit'
	StrCmp $LaunchAndExit 'true' LaunchAndExit		
		;===Launch a full standard launch
			InitPluginsDir
			CreateDirectory "$PLUGINSDIR\ContainedTemp"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("TEMP", "$PLUGINSDIR\ContainedTemp").r0'
			ExecWait $ExecString
			RMDir /r "$PLUGINSDIR\ContainedTemp"
			;MessageBox MB_OK "$ExecString"

				StrCmp $ExistsXBEL "true" +2
					Delete "$USERPROFILE\.recently-used.xbel"
				StrCmp $GTKBookmarks "true" +2
					Delete "$USERPROFILE\.gtk-bookmarks"
				StrCmp $ExistsFileChooser "true" +3
					Delete "$APPDATA\gtk-2.0\gtkfilechooser.ini"
					RmDir "$APPDATA\gtk-2.0\"
				;===Fix enchant issue
				StrCmp $EnchantExisted "false" +2 0
					IfFileExists "$APPDATA\enchant-backup-by-Geany-Portable\*.*" 0 +3
					RmDir /r "$APPDATA\enchant" ;nothing of worth is in this directory
					Rename "$APPDATA\enchant-backup-by-Geany-Portable" "$APPDATA\enchant"
				;===Put gtkrc back where it belongs
					Rename "$GTKDirectory\etc\gtk-2.0\gtkrc" "$SettingsDirectory\gtkrc"
				
				;===Remove Fonts
				;Code Courtesy wraithdu\ErikPilsits	
				StrCmp $UseFonts "false" TheEnd
					; loop through fonts and add or remove
					FindFirst $0 $1 "$FontDirectory\*.*"
					${DoWhile} $1 != ""
						${If} $1 != "."
						${AndIf} $1 != ".."
							System::Call "gdi32::RemoveFontResource(t'$FontDirectory\$1')i .r2"
							;${IfThen} $2 = 0 ${|} MessageBox MB_OK|MB_ICONEXCLAMATION "Error removing font <$1>" ${|}
						${EndIf}
						FindNext $0 $1
					${Loop}
					FindClose $0
					; broadcast font change
					SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=1
				Goto TheEnd ;I really wish I could get away without such a blatant goto.  But I can't

	LaunchAndExit:
		Exec $ExecString

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd
