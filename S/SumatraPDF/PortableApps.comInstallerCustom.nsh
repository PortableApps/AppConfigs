!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.5.0.0" $R0
		${If} $R0 == "2"
			Rename "$INSTDIR\App\SumatraPDF\sumatrapdfcache" "$INSTDIR\Data\sumatrapdfcache"
		${EndIf}
	${EndIf}
!macroend
