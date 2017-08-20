!macro CustomCodePreInstall
	IfFileExists "$INSTDIR\App\AppInfo\appinfo.ini" "" CustomCodePreInstallEnd
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "DisplayVersion"
			${VersionCompare} "$0" "0.96.1.2" $1
				StrCmp $1 "2" "" CustomCodePreInstallEnd
					Delete "$INSTDIR\Data\db\*.*"

	CustomCodePreInstallEnd:
!macroend