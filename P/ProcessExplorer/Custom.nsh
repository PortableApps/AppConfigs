!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_LEGACY_PROCEXP

${SegmentPrePrimary}
	${registry::KeyExists} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCEXP152" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_PROCEXP true
	${EndIf}
!macroend

${SegmentPostPrimary}
	${IfNot} $Exists_LEGACY_PROCEXP == true
		AccessControl::GrantOnRegKey \
		HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCEXP152" "(S-1-5-32-545)" "FullAccess"
		Pop $R0
		${If} $R0 == error
			Pop $R0
		;	MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
		${Else}
			${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCEXP152" $R0
		${EndIf}
	${EndIf}
!macroend
