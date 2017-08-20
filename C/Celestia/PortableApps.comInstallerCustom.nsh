!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\celestia_portable.reg"
		DeleteINIStr "$INSTDIR\Data\settings\celestia_portable.reg" "HKEY_CURRENT_USER\Software\Shatters.net" `"Lang"`
	${EndIf}
!macroend