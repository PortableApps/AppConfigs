!macro CustomCodePreInstall
	CreateDirectory "$INSTDIR\Data\Downloaded Podcasts"
	IfFileExists "$INSTDIR\Data\settings\iPodder" "" CustomCodePreInstallEnd
		Rename "$INSTDIR\Data\settings\iPodder" "$INSTDIR\Data\iPodder"
		
	CustomCodePreInstallEnd:
!macroend