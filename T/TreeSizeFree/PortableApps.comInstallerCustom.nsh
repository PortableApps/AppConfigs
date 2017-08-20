!macro CustomCodePostInstall
	${If} $LANGUAGE == "1031" ;German
		Rename "$INSTDIR\App\TreeSizeFree\TreeSizeFree.chm" "$INSTDIR\App\TreeSizeFree\TreeSizeFree_EN.chm"
		Rename "$INSTDIR\App\TreeSizeFree\TreeSizeFree_DE.chm" "$INSTDIR\App\TreeSizeFree\TreeSizeFree.chm"
	${EndIf}
!macroend