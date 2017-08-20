!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "1.3.99.1" $1
		${If} $1 == "2"  ;$0 is older than
			RMDir /r "$INSTDIR\Data"
		${EndIf}
	${EndIf}
!macroend