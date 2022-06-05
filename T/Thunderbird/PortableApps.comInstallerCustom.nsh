Var strInstallerCustomVersionPreInstall

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini" 
		ReadINIStr $strInstallerCustomVersionPreInstall "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
	${EndIf}
!macroend

!macro CustomCodePostInstall
	CreateDirectory "$INSTDIR\Data\settings"
	WriteINIStr "$INSTDIR\Data\settings\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "AgreedToLicense" "YES"
	
	${If} ${FileExists} "$INSTDIR\Data\profile\*.*"
		${VersionCompare} $strInstallerCustomVersionPreInstall "78.6.1.0" $R0
		${If} $R0 == 2
			Delete "$INSTDIR\Data\settings\update-config.json"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\update-config.json" "$INSTDIR\Data\settings"
		${EndIf}
	${EndIf}
!macroend