!macro CustomCodePreInstall
	IfFileExists "$INSTDIR\Data\settings\supertuxkart.cfg" "" CustomCodePreInstallEnd
		CreateDirectory "$INSTDIR\Data\supertuxkart"
		Rename "$INSTDIR\Data\settings\highscore.data" "$INSTDIR\Data\supertuxkart\highscore.data"
		Rename "$INSTDIR\Data\settings\supertuxkart.cfg" "$INSTDIR\Data\supertuxkart\supertuxkart.cfg"
		
	CustomCodePreInstallEnd:
!macroend