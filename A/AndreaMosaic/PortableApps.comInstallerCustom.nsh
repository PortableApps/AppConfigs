Var customUpgradeFromRegistryVersion

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "3.34.0.0" $R0
		${If} $R0 == "2"
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\*.*"
			StrCpy $customUpgradeFromRegistryVersion true
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} $customUpgradeFromRegistryVersion == true
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\AndreaMosaicConfig.txt" "$INSTDIR\Data"
	${EndIf}
!macroend