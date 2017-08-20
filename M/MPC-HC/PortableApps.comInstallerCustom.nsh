!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.7.7.0" $R0
		${If} $R0 == 2
			Rename "$INSTDIR\App\MPC-HC\default.mpcpl" "$INSTDIR\Data\settings\default.mpcpl"
		${EndIf}
	${EndIf}
!macroend