Var strInstallerCustomVersionPreInstall

!macro CustomCodePreInstall
	ReadINIStr $strInstallerCustomVersionPreInstall "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
	${If} ${FileExists} "$INSTDIR\Data\.openshot_qt\openshot.settings"
		${VersionCompare} $strInstallerCustomVersionPreInstall "3.1.0.2" $R0
		${If} $R0 == 2
			Rename "$INSTDIR\Data\.openshot_qt\openshot.settings" "$INSTDIR\Data\.openshot_qt\openshot.settings-old"
		${EndIf}
	${EndIf}
!macroend
