!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\filezilla.xml"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\settings\filezilla-putty.reg"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\filezilla-putty.reg" "$INSTDIR\Data\settings"
	${EndIf}
!macroend