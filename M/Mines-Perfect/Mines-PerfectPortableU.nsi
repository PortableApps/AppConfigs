;Copyright (C) 2004-2012 John T. Haller

;Website: http://PortableApps.com/FileZillaPortable

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

!define NAME "Mines-PerfectPortable"
!define PORTABLEAPPNAME "Mines-Perfect Portable"
!define APPNAME "Mines-Perfect"
!define VER "1.5.9.0"
!define WEBSITE "PortableApps.com/Mines-PerfectPortable"

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
XPStyle On

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
!include FileFunc.nsh
!insertmacro GetParent
!include CheckForPlatformSplashDisable.nsh

Var DISABLESPLASHSCREEN

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutex(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckINI TheEnd
	
	CheckINI:
		;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\Mines-PerfectPortable.ini" "" ShowSplash

		;=== Read the parameters from the INI file
		ReadINIStr $DISABLESPLASHSCREEN "$EXEDIR\Mines-PerfectPortable.ini" "Mines-PerfectPortable" "DisableSplashScreen"


	ShowSplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
		;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L "$PLUGINSDIR\splash.jpg"

	SkipSplashScreen:
		;=== Check for data files
		IfFileExists `$EXEDIR\App\Mines-Perfect\mineperf.ini` LaunchNow
		IfFileExists `$EXEDIR\Data\settings\mineperf.ini` MoveSettings
		IfFileExists `$EXEDIR\Data\settings\*.*` MoveSettings
			CreateDirectory `$EXEDIR\Data\settings`

	MoveSettings:
		Rename `$EXEDIR\Data\settings\mineperf.ini` `$EXEDIR\App\Mines-Perfect\mineperf.ini`

	LaunchNow:
		SetOutPath `$EXEDIR\App\Mines-Perfect`
		ExecWait `$EXEDIR\App\Mines-Perfect\mineperf.exe`

		;=== Move settings back
		Delete `$EXEDIR\Data\settings\mineperf.ini`
		Rename "$EXEDIR\App\Mines-Perfect\mineperf.ini" "$EXEDIR\Data\settings\mineperf.ini"

	TheEnd:
		newadvsplash::stop /WAIT
SectionEnd