!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\Data\Settings.ini"
		Rename "$INSTDIR\Data\Data\Backgrounds" "$INSTDIR\Data\Backgrounds"
		Rename "$INSTDIR\Data\Data\Converters" "$INSTDIR\Data\Converters"
		Rename "$INSTDIR\Data\Data\Custom Spell" "$INSTDIR\Data\Custom Spell"
		Rename "$INSTDIR\Data\Data\Document Backups" "$INSTDIR\Data\Document Backups"
		Rename "$INSTDIR\Data\Data\Templates" "$INSTDIR\Data\Templates"
		Rename "$INSTDIR\Data\Data\Settings.ini" "$INSTDIR\Data\Settings.ini"
		RMDir "$INSTDIR\Data\Data"
	${EndIf}
!macroend