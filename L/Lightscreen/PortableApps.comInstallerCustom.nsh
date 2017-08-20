!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\lightscreen.reg"
		Rename "$INSTDIR\Data\settings\lightscreen.reg" "$INSTDIR\Data\settings\lightscreen.reg.old"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\*.*" "$INSTDIR\Data\settings"
	${EndIf}
!macroend
