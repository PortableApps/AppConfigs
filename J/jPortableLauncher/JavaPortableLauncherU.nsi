;Copyright (C) 2004-2017 John T. Haller

;Website: http://PortableApps.com/JavaPortableLauncher

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

!define PORTABLEAPPNAME "jPortable Launcher"
!define NAME "JavaPortableLauncher"
!define APPNAME "Java Apps"
!define VER "4.0.0.0"
!define WEBSITE "PortableApps.com/go/jPortableLauncher"
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
Unicode true
ManifestDPIAware true
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
;(Standard NSIS)
!include LogicLib.nsh
!include Registry.nsh
!include FileFunc.nsh
!insertmacro GetParameters
!insertmacro GetParent
!include WordFunc.nsh
!insertmacro WordReplace

;(Custom)
!include ReadINIStrWithDefault.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PortableAppsPath
Var MISSINGFILEORPATH
Var JarPath
Var LastPathUsed
Var JavaPath

Section "Main"
	${GetParent} $EXEDIR $PortableAppsPath
	
	${If} ${FileExists} "$PortableAppsPath\CommonFiles\Java\bin\javaw.exe"
		StrCpy $JavaPath "$PortableAppsPath\CommonFiles\Java"
	${ElseIf} ${FileExists} "$PortableAppsPath\CommonFiles\JDK\jre\bin\javaw.exe"
		StrCpy $JavaPath "$PortableAppsPath\CommonFiles\JDK\jre"
	${Else}
		StrCpy $JavaPath "NONE"
	${EndIf}
	
	${If} $JavaPath != "NONE"
		${GetParameters} $JarPath
		${WordReplace} $JarPath '"' "" "+" $R0 ;Removes quotes
		StrCpy $JarPath '$R0'
		${If} $JarPath == ""
			;Prompt the user for the JAR
			${GetRoot} $EXEDIR $0
			${ReadINIStrWithDefault} $LastPathUsed "$EXEDIR\Data\JavaPortableLauncher.ini" "JavaPortableLauncher" "LastPathUsed" ""
			${If} $LastPathUsed == ""
				StrCpy $LastPathUsed $0
			${Else}
				${IfNot} ${FileExists} $LastPathUsed
					StrCpy $1 $LastPathUsed "" 2
					${If} ${FileExists} "$0$1"
						StrCpy $LastPathUsed "$0$1"
					${Else}
						StrCpy $LastPathUsed $0
					${EndIf}
				${EndIf}
			${EndIf}
			nsDialogs::SelectFileDialog open $LastPathUsed "JAR Files|*.jar|All Files|*.*"
			Pop $JarPath
			${If} $JarPath != ""
				CreateDirectory "$EXEDIR\Data"
				${GetParent} $JarPath $0
				WriteINIStr "$EXEDIR\Data\JavaPortableLauncher.ini" "JavaPortableLauncher" "LastPathUsed" "$0"
			${EndIf}
		${EndIf}
		${WordReplace} $JarPath '"' "" "+" $JarPath ;Removes quotes
		${If} $JarPath != ""
			${If} ${FileExists} $JarPath
				;Set our environment variables
				System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("JAVAHOME", "$JavaPath").r0'
				System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("CLASSPATH", ".").r0'
				CreateDirectory "$EXEDIR\Data"
				CreateDirectory "$EXEDIR\Data\AppData"
				System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("APPDATA", "$EXEDIR\Data\AppData").r0'
				SetOutPath $0
				Exec `"$JavaPath\bin\javaw.exe" -Duser.home="$EXEDIR\Data\AppData" -jar "$JarPath"`
			${Else}
				StrCpy $MISSINGFILEORPATH $JarPath
				MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherFileNotFound)`
			${EndIf}
		${EndIf}
	${Else}
		StrCpy $MISSINGFILEORPATH "jPortable [http://PortableApps.com/jPortable]"
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherFileNotFound)`
	${EndIf}
SectionEnd