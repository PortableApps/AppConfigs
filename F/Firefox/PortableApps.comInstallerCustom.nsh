!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\profile\*.*"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "20.0.0.0" $R0
		${If} $R0 == 2
			WriteINIStr "$INSTDIR\Data\settings\FirefoxPortableSettings.ini" "FirefoxPortableSettings" "SubmitCrashReport" "0"
		${EndIf}
	${EndIf}
!macroend
