!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\profile\*.*"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.17.0.0" $R0
		${If} $R0 == 2
			WriteINIStr "$INSTDIR\Data\settings\SeaMonkeyPortableSettings.ini" "SeaMonkeyPortableSettings" "SubmitCrashReport" "0"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	;Ensure warning isn't shown if invalid package is properly upgraded
	${If} ${FileExists} "$INSTDIR\LupoApp.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		CreateDirectory "$INSTDIR\Data"
		CreateDirectory "$INSTDIR\Data\settings"
		WriteINIStr "$INSTDIR\Data\settings\SeaMonkeyPortableSettings.ini" "SeaMonkeyPortableSettings" "InvalidPackageWarningShown" $0
	${EndIf}
!macroend