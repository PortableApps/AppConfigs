!macro CustomCodePreInstall
	IfFileExists "$INSTDIR\Data\settings\JPEGView.ini" "" CustomCodePreInstallEnd
		WriteINIStr "$INSTDIR\Data\settings\JPEGView.ini" "JPEGView" "StoreToEXEPath" "true"
	CustomCodePreInstallEnd:
!macroend