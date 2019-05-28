!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "7.54.99.99" $R0
		${If} $R0 == 2
		${AndIf} ${FileExists} "$INSTDIR\Data\Q-Dir.ini"
			WriteINIStr "$INSTDIR\Data\Q-Dir.ini" "Q-Dir" "enable_auto_update" "0"
		${EndIf}
	${EndIf}
!macroend
