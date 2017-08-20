!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_LEGACY_IOBITUNLOCKER
Var Exists_Services_IObitUnlocker

${Segment.OnInit}
	; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0
		StrCpy $Bits 32
	${Else}
		StrCpy $Bits 64
	${EndIf}
!macroend

${SegmentPrePrimary}
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_IOBITUNLOCKER true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_IObitUnlocker true
	${EndIf}

	Delete "$EXEDIR\App\IObitUnlocker\IObitUnlocker.sys"
	Delete "$EXEDIR\App\IObitUnlocker\IObitUnlockerExtension.dll"
    ${If} $Bits = 64
		${If} ${AtLeastWinVista}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern64\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern64\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${Else}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysLegacy64\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysLegacy64\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${EndIf}
    ${Else}
		${If} ${AtLeastWinVista}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern32\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern32\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${Else}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysLegacy32\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysLegacy32\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${EndIf}
    ${EndIf}
!macroend

${SegmentPostPrimary}	
	${IfNot} $Exists_LEGACY_IOBITUNLOCKER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_IObitUnlocker == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\IObitUnlocker" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
			${EndIf}
		${EndIf}
	${EndIf}
!macroend