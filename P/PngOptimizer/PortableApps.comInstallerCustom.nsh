!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\*.*"
		CreateDirectory "$INSTDIR\Data\Screenshots"
	${EndIf}
!macroend