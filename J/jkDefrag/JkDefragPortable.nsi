;Copyright (C) 2004-2012 John T. Haller
;Copyright (C) 2008 Travis Carrico

;Website: http://PortableApps.com/JkDefragPortable

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

!define PORTABLEAPPNAME "JkDefrag Portable"
!define APPNAME "JkDefrag"
!define NAME "JkDefragPortable"
!define VER "1.6.0.0"
!define WEBSITE "PortableApps.com/JkDefragPortable"
!define DEFAULTEXE "JkDefragGUI.exe"
!define DEFAULTAPPDIR "JkDefrag"
!define LAUNCHERLANGUAGE "English"

;**************************************************************************************************************
;Note: this launcher code has had many changes to the normal PortableApps template and probably should not be used as a starting point for any other app.
;**************************************************************************************************************

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "PortableApps.com and contributers"
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
RequestExecutionLevel admin

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
!include FileFunc.nsh
!insertmacro GetParameters
!include LogicLib.nsh
!include x64.nsh
;Custom
!include CheckForPlatformSplashDisable.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
;Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var SECONDARYLAUNCH
Var DISABLESPLASHSCREEN
Var MISSINGFILEORPATH
Var OTHEREXE
Var FLASH

Section "Main"
	${If} ${RunningX64}
		StrCpy "$OTHEREXE" "JkDefrag64.exe"
	${Else}
		StrCpy "$OTHEREXE" "JkDefrag.exe"
	${EndIf}

	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckINI
		StrCpy $SECONDARYLAUNCH "true"

	CheckINI:
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" CheckSubINI
			StrCpy "$INIPATH" "$EXEDIR"
			Goto ReadINI

	CheckSubINI:
		IfFileExists "$EXEDIR\${NAME}\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR\${NAME}"
			Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory"
		StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\$0"
		;ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory"
		;StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\$0"
		ReadINIStr $0 "$INIPATH\${NAME}.ini" "${NAME}" "EnableFlashDrives"
		StrCpy "$FLASH" "$0"

		;=== Check that the above required parameters are present
		IfErrors NoINI
		ReadINIStr $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters"
		ReadINIStr $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable"
		ReadINIStr $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen"

	;CleanUpAnyErrors:
		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Correct PROGRAMEXECUTABLE if blank
		StrCmp $PROGRAMEXECUTABLE "" "" EndINI
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
			Goto EndINI

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\$OTHEREXE" "" NoOtherEXE
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			;StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\settings"
			GoTo EndINI

	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
	
	NoOtherEXE:
		StrCpy $MISSINGFILEORPATH $OTHEREXE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		;=== Check if running
		StrCmp $SECONDARYLAUNCH "true" WarnAnotherPortableInstance
		FindProcDLL::FindProc "${DEFAULTEXE}"
		StrCmp $R0 "1" WarnAnotherInstance
		FindProcDLL::FindProc "$OTHEREXE"
		StrCmp $R0 "1" WarnAnotherInstance DisplaySplash

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	WarnAnotherPortableInstance:
		MessageBox MB_OK|MB_ICONINFORMATION "Another instance of ${PORTABLEAPPNAME} is already running. Only one instance of ${PORTABLEAPPNAME} can run at a time."
		Abort
	
	DisplaySplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
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
		StrCmp $ADDITIONALPARAMETERS "" CheckForSettings

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`
	
	;SettingsDirectory:
		;=== Set the settings directory if we have a path
		;IfFileExists "$SETTINGSDIRECTORY\*.*" CheckForSettings
			;CreateDirectory $SETTINGSDIRECTORY
	
	CheckForSettings:
		;StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		StrCmp $FLASH "true" "" LaunchNow
		StrCpy '$EXECSTRING' '$EXECSTRING /flash'
		
	LaunchNow:
		SetOutPath "$PROGRAMDIRECTORY"
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning
		FindProcDLL::FindProc "$OTHEREXE"                  
		StrCmp $R0 "1" CheckRunning
		Delete "JkDefrag.txt"
		Sleep 500
		Goto TheEnd
	
	;LaunchAndExit:
		;SetOutPath "$PROGRAMDIRECTORY"
		;Exec $EXECSTRING

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd