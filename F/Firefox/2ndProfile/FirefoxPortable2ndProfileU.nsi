;Copyright 2010-2017 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/FirefoxPortable

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

!define PORTABLEAPPNAME "Mozilla Firefox, Portable Edition 2nd Profile"
!define APPNAME "Firefox"
!define NAME "FirefoxPortable2ndProfile"
!define VER "2.0.0.0"
!define WEBSITE "PortableApps.com/FirefoxPortable"
!define DEFAULTEXE "firefox.exe"
!define DEFAULTAPPDIR "firefox"
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
VIAddVersionKey LegalTrademarks "Firefox is a Registered Trademark of The Mozilla Foundation.  PortableApps.com is a Registered Trademark of Rare Ideas, LLC."
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
!insertmacro GetParameters ;Requires NSIS 2.40 or better
!include LogicLib.nsh
!include TextFunc.nsh
!insertmacro GetParent

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var MISSINGFILEORPATH
Var strPortableAppsPath

Section "Main"
	${GetParent} $EXEDIR $strPortableAppsPath

	${If} ${FileExists} `$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe`
		;Check if already running
		FindProcDLL::FindProc "FirefoxPortable.exe"
		${If} $R0 != "1"
			;Not Running
			Delete "$EXEDIR\Data\FirefoxPortable.exe"
			CreateDirectory "$EXEDIR\Data"
			CopyFiles /SILENT "$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe" "$EXEDIR\Data"
			
			;Setup INI File
			${IfNot} ${FileExists} `$EXEDIR\Data\FirefoxPortable.ini`
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\FirefoxPortable.ini" "$EXEDIR\Data"
			${EndIf}
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "FirefoxDirectory" "..\..\FirefoxPortable\App\firefox"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "ProfileDirectory" "profile"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "SettingsDirectory" "settings"
			WriteINIStr "$EXEDIR\Data\FirefoxPortable.ini" "FirefoxPortable" "PluginsDirectory" "plugins"
			
			;Check for profile
			${IfNot} ${FileExists} `$EXEDIR\Data\profile\*.*`
				CreateDirectory "$EXEDIR\Data"
				CreateDirectory "$EXEDIR\Data\plugins"
				CreateDirectory "$EXEDIR\Data\profile"
				CreateDirectory "$EXEDIR\Data\settings"
				CopyFiles /SILENT "$strPortableAppsPath\FirefoxPortable\App\DefaultData\plugins\*.*" "$EXEDIR\Data\plugins"
				CopyFiles /SILENT "$strPortableAppsPath\FirefoxPortable\App\DefaultData\profile\*.*" "$EXEDIR\Data\profile"
				CopyFiles /SILENT "$strPortableAppsPath\FirefoxPortable\App\DefaultData\settings\*.*" "$EXEDIR\Data\settings"
			${EndIf}
			
			;Check command line paramters
			${GetParameters} $0
			${If} $0 == ""
				Exec `"$EXEDIR\Data\FirefoxPortable.exe"`
			${Else}
				Exec `"$EXEDIR\Data\FirefoxPortable.exe" $0`
			${EndIf}
		${Else}
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		${EndIf}
	${Else}
		StrCpy $MISSINGFILEORPATH "$strPortableAppsPath\FirefoxPortable\FirefoxPortable.exe"
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
	${EndIf}
SectionEnd