!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_LEGACY_IPFILTERDRIVER
Var Exists_Services_IPFILTERDRIVER

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

${SegmentInit}
    ${If} $Bits = 64
		${If} ${AtLeastWinVista}
			${SetEnvironmentVariablesPath} CustomFullPath "$EXEDIR\App\PeerBlock\Modern64"
		${Else}
			${SetEnvironmentVariablesPath} CustomFullPath "$EXEDIR\App\PeerBlock\Legacy64"
		${EndIf}
    ${Else}
		${If} ${AtLeastWinVista}
			${SetEnvironmentVariablesPath} CustomFullPath "$EXEDIR\App\PeerBlock\Modern32"
		${Else}
			${SetEnvironmentVariablesPath} CustomFullPath "$EXEDIR\App\PeerBlock\Legacy32"
		${EndIf}
    ${EndIf}
!macroend

${SegmentPrePrimary}
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPFILTERDRIVER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_IPFILTERDRIVER true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IpFilterDriver\Enum" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_IPFILTERDRIVER true
	${EndIf}
	
	${IfNot} ${AtLeastWinVista}
		${WordReplace} $ExecString "App\PeerBlock\Modern" "App\PeerBlock\Legacy" "+" $ExecString
	${EndIf}
!macroend

${SegmentPostPrimary}	
	${IfNot} $Exists_LEGACY_IPFILTERDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPFILTERDRIVER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPFILTERDRIVER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IPFILTERDRIVER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_IPFILTERDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IpFilterDriver" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\IpFilterDriver\Enum" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\IpFilterDriver\Enum" $R0
			${EndIf}
		${EndIf}
	${EndIf}
!macroend