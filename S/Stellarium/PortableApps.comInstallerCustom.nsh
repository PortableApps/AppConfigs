!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "0.11.2.0" $1
		${If} $1 == "2"  ;$0 is older than
			CreateDirectory "$INSTDIR\Data\Stellarium"
			CopyFiles "$INSTDIR\Data\settings\*.*" "$INSTDIR\Data\Stellarium"
			Delete "$INSTDIR\Data\Stellarium\StellariumPortableSettings.ini"
			RMDIR /r "$INSTDIR\Data\settings"
		${EndIf}
	${EndIf}
!macroend