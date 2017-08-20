!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\DVDStyler.reg"
		CreateDirectory "$INSTDIR\Data\OldSettings"
		Rename "$INSTDIR\Data\settings\DVDStyler.reg" "$INSTDIR\Data\OldSettings\DVDStyler.reg"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\DVDStyler.ini" "$INSTDIR\Data"
	${EndIf}
!macroend