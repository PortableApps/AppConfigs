!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\IDPhotoStudioPortableSettings.ini"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\settings.ini"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings.ini" "$INSTDIR\Data"
	${EndIf}
!macroend