!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "0.92.3.0" $R0
		${If} $R0 == "2"
			${If} ${FileExists} "$INSTDIR\Data\*.*"
				CopyFiles "$INSTDIR\App\DefaultData\01-portableapps.conf" "$INSTDIR\Data"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend