!macro CustomCodePreInstall
	IfFileExists "$INSTDIR\App\AppInfo\appinfo.ini" "" CustomCodePreInstallEnd
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
			${VersionCompare} $0 "1.3.10.992" $R0
			StrCmp $R0 "2" "" CustomCodePreInstallEnd
				RMDir /r "$INSTDIR\Data"

	CustomCodePreInstallEnd:
!macroend