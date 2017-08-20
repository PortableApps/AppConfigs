!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.01.0.2" $R0
		${If} $R0 == 2
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\Config.ini"
			WriteINIStr "$INSTDIR\Data\settings\Config.ini" "General" "AutoUpdate" "0"
			WriteINIStr "$INSTDIR\Data\settings\Config.ini" "General" "News" "0"
			WriteINIStr "$INSTDIR\Data\settings\Config.ini" "GUI" "Delecting" "0"
		${EndIf}
	${EndIf}
!macroend
