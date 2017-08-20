!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\2048Settings\file__0.localstorage"
		Rename "$INSTDIR\Data\2048Settings\file__0.localstorage" "$INSTDIR\Data\2048Settings\chrome-extension_mgldfmkchmokpgmkocmphhmdncefdihg_0.localstorage"
		Rename "$INSTDIR\Data\2048Settings\file__0.localstorage-journal" "$INSTDIR\Data\2048Settings\chrome-extension_mgldfmkchmokpgmkocmphhmdncefdihg_0.localstorage-journal"
	${EndIf}
!macroend