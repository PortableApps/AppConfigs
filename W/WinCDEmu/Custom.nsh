!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_EnumDRIVER
Var Exists_LegacyDRIVER
Var Exists_ServicesDRIVER

${SegmentPrePrimary}
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_BAZISPORTABLECDBUS" $R0
	${If} $R0 = 0
		StrCpy $Exists_LegacyDRIVER true
	${EndIf}

	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\BazisVirtualCDBus" $R0
	${If} $R0 = 0
		StrCpy $Exists_EnumDRIVER true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\BazisPortableCDBus" $R0
	${If} $R0 = 0
		StrCpy $Exists_ServicesDRIVER true
	${EndIf}

	nsExec::Exec '"$EXEDIR\App\WinCDEmu\PortableWinCDEmu-x.x.exe" /install'
!macroend

${SegmentPostPrimary}
	nsExec::Exec '"$EXEDIR\App\WinCDEmu\PortableWinCDEmu-x.x.exe" /uninstall'
	
	Sleep 1000
	
	${IfNot} $Exists_LegacyDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_BAZISPORTABLECDBUS" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_BAZISPORTABLECDBUS" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_BAZISPORTABLECDBUS" $R0
			${EndIf}
		${EndIf}
	${EndIf}

	${IfNot} $Exists_EnumDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\BazisVirtualCDBus" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\BazisVirtualCDBus" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\BazisVirtualCDBus" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_ServicesDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\BazisPortableCDBus" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\BazisPortableCDBus" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\BazisPortableCDBus" $R0
			${EndIf}
		${EndIf}
	${EndIf}
!macroend