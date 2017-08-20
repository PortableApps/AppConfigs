;Copyright (C) 2004-2017 John T. Haller of PortableApps.com

;Website: http://portableapps.com/PuTTYPortable

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

!define NAME "PuTTYPortableLinker"
!define FULLNAME "PuTTY Portable Linker"
!define APP "PuTTY"
!define VER "1.6.4.0"
!define WEBSITE "PortableApps.com/WinSCPPortable"

;=== Program Details
Name "${FULLNAME}"
OutFile "${NAME}.exe"
Caption "${FULLNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${FULLNAME}"
VIAddVersionKey Comments "Allows ${APP} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${FULLNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${FULLNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a trademark of Rare Ideas, LLC."
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
Unicode true
ManifestDPIAware true

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParent
!insertmacro GetParameters
!include Registry.nsh

;=== Program Icon
Icon "${NAME}.ico"

Var EXECSTRING
Var PORTABLEAPPSDIRECTORY

Section "Main"
	;=== Check for EXE
	${GetParent} "$EXEDIR" $0
	${GetParent} $0 $0
	${GetParent} $0 $PORTABLEAPPSDIRECTORY
	IfFileExists `$PORTABLEAPPSDIRECTORY\PuTTYPortable\PuTTYPortable.exe` FoundProgramEXE
		MessageBox MB_OK|MB_ICONINFORMATION `Could not locate $PORTABLEAPPSDIRECTORY\PuTTYPortable\PuTTYPortable.exe.  Please ensure that PuTTY Portable and WinSCP Portable are installed within your PortableApps directory.`
		Abort

	FoundProgramEXE:
		;=== Check if running
		FindProcDLL::FindProc "PuTTYPortable.exe"
		StrCmp $R0 "1" GetPassedParameters WarnAnotherInstance

	WarnAnotherInstance:
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions\WinSCP%20Portable%20Temporary%20Session" $R0
		MessageBox MB_OK|MB_ICONINFORMATION `Please start PuTTY Portable before attempting to use PuTTY integration within WinSCP Portable.`
		Abort
	
	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PORTABLEAPPSDIRECTORY\PuTTYPortable\PuTTYPortable.exe"`
		Goto StartPuTTYPortable

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PORTABLEAPPSDIRECTORY\PuTTYPortable\PuTTYPortable.exe" $0`
		
	StartPuTTYPortable:
		Exec $EXECSTRING
SectionEnd