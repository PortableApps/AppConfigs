!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_3A1380F4
Var Exists_LEGACY_PROCMON23

${SegmentPrePrimary}

	${registry::KeyExists} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{3A1380F4-708F-49DE-B2EF-04D25EB009D5}" $R0
	${If} $R0 = 0
		StrCpy $Exists_3A1380F4 true
	${EndIf}

	${registry::KeyExists} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCMON23" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_PROCMON23 true
	${EndIf}

!macroend

${SegmentPostPrimary}

	${IfNot} $Exists_3A1380F4 == true
		AccessControl::GrantOnRegKey \
		HKLM "SYSTEM\CurrentControlSet\Control\Class\{3A1380F4-708F-49DE-B2EF-04D25EB009D5}\Properties" "(S-1-5-32-545)" "FullAccess"
		Pop $R0
		${If} $R0 == error
			Pop $R0
			; MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
		${Else}
			${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{3A1380F4-708F-49DE-B2EF-04D25EB009D5}" $R0
		${EndIf}
	${EndIf}

	${IfNot} $Exists_LEGACY_PROCMON23 == true
		AccessControl::GrantOnRegKey \
		HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCMON23" "(S-1-5-32-545)" "FullAccess"
		Pop $R0
		${If} $R0 == error
			Pop $R0
			; MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
		${Else}
			${registry::DeleteKey} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_PROCMON23" $R0
		${EndIf}
	${EndIf}

!macroend
