!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data"
		CreateDirectory "$INSTDIR\Data\Temp"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "2.4.3.0" $1
		${If} $1 == 2
			${If} ${FileExists} "$INSTDIR\Data\Settings\GnuCashPortableSettings.ini"
				WriteINIStr "$INSTDIR\Data\Settings\GnuCashPortableSettings.ini" "GnuCashPortableSettings" "WarnedNoAdmin" ""
			${EndIf}
		${EndIf}
	${EndIf}
!macroend
