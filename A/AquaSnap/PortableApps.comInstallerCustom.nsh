!macro CustomCodePostInstall

	${If} ${FileExists} "$INSTDIR\Data\AquaSnap.ini"
	${ConfigWrite} "$$INSTDIR\Data\AquaSnap.ini" "InstallerName=" "1" $R0
	${EndIf}
!macroend
