!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "2.57.2.0" $1
		${If} $1 == "2"  ;$0 is older than 2.57.2.0
			RMDir /r "$INSTDIR\Data\settings"
		${EndIf}
	${EndIf}
!macroend