;Copyright (C) 2004-2010 John T. Haller of PortableApps.com
;Copyright (C) 2010 Michael Secord

;Website: http://PortableApps.com/DamnVidPortable

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

!define PORTABLEAPPNAME "DamnVid Portable"
!define APPNAME "DamnVid"
!define NAME "DamnVidPortable"
!define VER "1.6.7.0"
!define WEBSITE "PortableApps.com/DamnVidPortable"
!define DEFAULTEXE "DamnVid.exe"
!define DEFAULTAPPDIR "DamnVid"
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

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;NSIS
!include FileFunc.nsh
!include TextFunc.nsh
!insertmacro GetParameters

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
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
Var MISSINGFILEORPATH
;Var LASTDRIVE
Var CURRENTDRIVE
;Var LASTEXEDIR
;Var LASTSETTINGSDIR
Var LOCALTEMP
Var VIDEODIR
Var TEMPDIR

Section "Main"
	;=== Find the INI file, if there is one
	${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$EXEDIR\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
	${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$EXEDIR\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
	${ReadINIStrWithDefault} $LOCALTEMP "$EXEDIR\${NAME}.ini" "${NAME}" "LocalTemp" "true"
	
	;=== Get Drive Letter
	${GetRoot} $EXEDIR $CURRENTDRIVE

	StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"

	IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\${DEFAULTSETTINGSDIR}"
		Goto CheckIfRunning

	CheckIfRunning:
		;=== Check if running
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance FoundProgramEXE

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
		
	NoProgramEXE:
		;=== Program executable not where expected
				StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 2000 0 0 -1 /L $PLUGINSDIR\splash.jpg

	SkipSplashScreen:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" SavedSettings
		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	SavedSettings:	
		;=== Check for our Saved Settings
		IfFileExists $SETTINGSDIRECTORY "" SettingsNotFound
		IfFileExists "$SETTINGSDIRECTORY\Settings\*.*" CheckVideoDir SettingsNotFound
	
	SettingsNotFound:
		;=== Create settings folder structure if it doesn't exist
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\settings"
		CreateDirectory "$EXEDIR\Data\settings\config"
		CreateDirectory "$EXEDIR\Data\settings\videos"
		CreateDirectory "$EXEDIR\Data\settings\temp"
		Goto CheckVideoDir
		
	CheckVideoDir:
		;=== Check where to store videos
		;=== Check EnvStr
		ReadEnvStr $VIDEODIR "PortableApps.comVideos"
		StrCmp $VIDEODIR "" ManuallyCheckForVideos
		${DirState} $VIDEODIR $R0
		StrCmp $R0 "-1" ManuallyCheckForVideos CheckTempDir

		ManuallyCheckForVideos:
			;=== Manually check for Platform Videos folder
			${DirState} $CURRENTDRIVE\Documents\Videos $R0
			StrCmp $R0 "-1" UseData
			StrCpy $VIDEODIR "$CURRENTDRIVE\Documents\Videos"
			Goto CheckTempDir

		UseData:
			StrCpy $VIDEODIR "$SETTINGSDIRECTORY\videos"
			
	CheckTempDir:
		;=== Check what temp directory to use based on ini
			StrCmp $LOCALTEMP "false" UseDataDir
			CreateDirectory "$TEMP\${NAME}"
			StrCpy $TEMPDIR "$TEMP\${NAME}"
			
		UseDataDir:
			StrCpy $TEMPDIR "$SETTINGSDIRECTORY\temp"
			Goto LaunchNow
		
	LaunchNow:
		SetOutPath `$EXEDIR\App\${DEFAULTAPPDIR}`
		;=== Add switches specifying data/config/video paths
		StrCpy $EXECSTRING `$EXECSTRING --config="$SETTINGSDIRECTORY\config" --temp="$TEMPDIR" --myvideos="$VIDEODIR"`
		Exec $EXECSTRING
		StrCmp $LOCALTEMP "true" WhileRunning TheEnd
		
	WhileRunning:
		Sleep 2000;
		FindProcDLL::FindProc "${DEFAULTEXE}"   
		StrCmp $R0 "1" WhileRunning
		Goto CleanupTemp
		
	CleanupTemp:
		RMDir /r "$TEMP\${NAME}"
		Goto TheEnd
		
	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd