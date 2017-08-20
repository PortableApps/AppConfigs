!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "1.0.20.0" $1
		${If} $1 == "2"  ;$0 is older than
			Rename "$INSTDIR\Data\settings\config.xml" "$INSTDIR\Data\config.xml"
		${EndIf}
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "1.0.21.0" $1
		${If} $1 == "2"  ;$0 is older than
			CreateDirectory "$INSTDIR\Data\cddb"
			CopyFiles /SILENT "$INSTDIR\App\freac\cddb\*.*" "$INSTDIR\Data\cddb"
			RMDir "$INSTDIR\App\freac\cddb"
		${EndIf}
	${EndIf}
!macroend