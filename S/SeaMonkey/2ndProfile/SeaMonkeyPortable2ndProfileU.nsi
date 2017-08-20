;Copyright 2010-2017 John T. Haller of PortableApps.com
;Website: http://PortableApps.com/SeaMonkeyPortable

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

!define PORTABLEAPPNAME "SeaMonkey, Portable Edition 2nd Profile"
!define APPNAME "SeaMonkey"
!define NAME "SeaMonkeyPortable2ndProfile"
!define VER "2.0.0.0"
!define WEBSITE "PortableApps.com/SeaMonkeyPortable"
!define DEFAULTEXE "seamonkey.exe"
!define DEFAULTAPPDIR "seamonkey"
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
VIAddVersionKey LegalTrademarks "SeaMonkey is a Registered Trademark of The Mozilla Foundation.  PortableApps.com is a Registered Trademark of Rare Ideas, LLC."
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

	${If} ${FileExists} `$strPortableAppsPath\SeaMonkeyPortable\SeaMonkeyPortable.exe`
		;Check if already running
		FindProcDLL::FindProc "SeaMonkeyPortable.exe"
		${If} $R0 != "1"
			;Not Running
			Delete "$EXEDIR\Data\SeaMonkeyPortable.exe"
			CreateDirectory "$EXEDIR\Data"
			CopyFiles /SILENT "$strPortableAppsPath\SeaMonkeyPortable\SeaMonkeyPortable.exe" "$EXEDIR\Data"
			
			;Setup INI File
			${IfNot} ${FileExists} `$EXEDIR\Data\SeaMonkeyPortable.ini`
				CopyFiles /SILENT "$EXEDIR\App\DefaultData\SeaMonkeyPortable.ini" "$EXEDIR\Data"
			${EndIf}
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "SeaMonkeyDirectory" "..\..\SeaMonkeyPortable\App\seamonkey"
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "ProfileDirectory" "profile"
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "SettingsDirectory" "settings"
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "PluginsDirectory" "plugins"
			
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "GPGFullPath" "$strPortableAppsPath\SeaMonkeyPortable\App\gpg"
			CreateDirectory "$EXEDIR\Data\gpg"
			WriteINIStr "$EXEDIR\Data\SeaMonkeyPortable.ini" "SeaMonkeyPortable" "GPGHomeFullPath" "$EXEDIR\Data\gpg"
			
			;Check for profile
			${IfNot} ${FileExists} `$EXEDIR\Data\profile\*.*`
				CreateDirectory "$EXEDIR\Data"
				CreateDirectory "$EXEDIR\Data\plugins"
				CreateDirectory "$EXEDIR\Data\profile"
				CreateDirectory "$EXEDIR\Data\settings"
				CreateDirectory "$EXEDIR\Data\gpg"
				CopyFiles /SILENT "$strPortableAppsPath\SeaMonkeyPortable\App\DefaultData\plugins\*.*" "$EXEDIR\Data\plugins"
				CopyFiles /SILENT "$strPortableAppsPath\SeaMonkeyPortable\App\DefaultData\profile\*.*" "$EXEDIR\Data\profile"
				CopyFiles /SILENT "$strPortableAppsPath\SeaMonkeyPortable\App\DefaultData\settings\*.*" "$EXEDIR\Data\settings"
			${EndIf}
			
			;Check command line paramters
			${GetParameters} $0
			${If} $0 == ""
				Exec `"$EXEDIR\Data\SeaMonkeyPortable.exe"`
			${Else}
				Exec `"$EXEDIR\Data\SeaMonkeyPortable.exe" $0`
			${EndIf}
		${Else}
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		${EndIf}
	${Else}
		StrCpy $MISSINGFILEORPATH "$strPortableAppsPath\SeaMonkeyPortable\SeaMonkeyPortable.exe"
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
	${EndIf}
SectionEnd