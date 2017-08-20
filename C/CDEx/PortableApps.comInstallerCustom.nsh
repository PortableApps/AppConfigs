Var customUpgradeFromRegistryVersion

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.7.0.0" $R0
		${If} $R0 == "2"
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\*.*"
			StrCpy $customUpgradeFromRegistryVersion true
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} $customUpgradeFromRegistryVersion == true
		${If} ${FileExists} "$INSTDIR\Data\settings\CDEx.ini"
			CopyFiles /SILENT "$INSTDIR\Other\InstallerUnicodeConversion\blank-utf16le.txt" "$INSTDIR\Data\settings"
			Rename "$INSTDIR\Data\settings\blank-utf16le.txt" "$INSTDIR\Data\settings\CDEx.ini-converted"
			CopyFiles /SILENT "$INSTDIR\Other\InstallerUnicodeConversion\blank-utf16le.txt" "$INSTDIR\Data\settings"
			Rename "$INSTDIR\Data\settings\blank-utf16le.txt" "$INSTDIR\Data\settings\Default.prf.ini-converted"
			
			nsExec::Exec /TIMEOUT=10000 `"$INSTDIR\Other\InstallerUnicodeConversion\win_iconv.bat" "$INSTDIR"`
			
			Delete "$INSTDIR\Data\settings\Default.prf.ini"
			Rename "$INSTDIR\Data\settings\Default.prf.ini-converted" "$INSTDIR\Data\settings\Default.prf.ini"
			Delete "$INSTDIR\Data\settings\CDEx.ini"
			Rename "$INSTDIR\Data\settings\CDEx.ini-converted" "$INSTDIR\Data\settings\CDEx.ini"
		${EndIf}
	${EndIf}
	RMDir /r "$INSTDIR\App\CDex\$$PLUGINSDIR"
	Delete "$INSTDIR\App\CDex\uninstall.exe"
	Delete "$INSTDIR\App\CDex\vc_redist.x86.exe"
!macroend