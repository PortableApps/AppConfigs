!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "0.7.6.804" $1
		${If} $1 == "2"  ;$0 is older than
			Delete "$INSTDIR\Data"
		${EndIf}
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\keepnote"
		CreateDirectory "$INSTDIR\Data\Notebooks"
	${EndIf}
!macroend