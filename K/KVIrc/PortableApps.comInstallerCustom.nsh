!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\KVIrc\Settings\*.*"
		CreateDirectory "$INSTDIR\Data\Archive"
		Rename "$INSTDIR\App\KVIrc\Settings" "$INSTDIR\Data\Archive\Settings"
		Rename "$INSTDIR\App\KVIrc\Downloads" "$INSTDIR\Data\Archive\Downloads"
	${EndIf}
!macroend