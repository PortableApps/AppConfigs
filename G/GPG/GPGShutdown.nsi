;Copyright (C) 2004-2015 John T. Haller of PortableApps.com

;Website: http://portableapps.com/

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

!define NAME "GPGShutdown"
!define FULLNAME "GPG Shutdown"
!define APP "GPG"
!define VER "1.0.0.0"
!define WEBSITE "portableapps.com/apps/security/gpg-plugin-portable"

;=== Program Details
Name "${FULLNAME}"
OutFile "..\..\${NAME}.exe"
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

;=== Include
;(Standard NSIS)
!include LogicLib.nsh

;(Custom]
!include ProcFunc.nsh

;=== Program Icon
Icon "${NAME}.ico"

Section "Main"
	${GetProcessPID} "gpg-agent.exe" $0
	
	;MessageBox MB_ICONINFORMATION "$0"

	${If} $0 > 0
		ExecWait `"$EXEDIR\gpg-connect-agent.exe" killagent /bye` $1
		;MessageBox MB_ICONINFORMATION "$1"
	${EndIf}
SectionEnd