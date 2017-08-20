!macro CustomCodePostInstall
	RMDir /r "$INSTDIR\.git"
	Delete "$INSTDIR\.gitignore"
!macroend