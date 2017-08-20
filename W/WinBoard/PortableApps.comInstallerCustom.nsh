!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "DisplayVersion"
		${If} $0 == "4.2.7 Development Test 1"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\*.*" "$INSTDIR\Data\settings"
		${EndIf}
	${EndIf}
	
	${If} ${FileExists} "$INSTDIR\Data\settings\defaults.ini"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\settings\mini.ini"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\mini.ini" "$INSTDIR\Data\settings"
	${EndIf}
!macroend