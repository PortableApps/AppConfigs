!macro CustomCodePreInstall
	;Ensure warning isn't shown if invalid package is properly upgraded
	${If} ${FileExists} "$INSTDIR\LupoApp.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		CreateDirectory "$INSTDIR\Data"
		CreateDirectory "$INSTDIR\Data\settings"
		WriteINIStr "$INSTDIR\Data\settings\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "InvalidPackageWarningShown" $0
	${EndIf}

	IfFileExists "$INSTDIR\App\AppInfo\appinfo.ini" "" CustomCodePreInstallEnd
		ReadINIStr $R0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		StrCpy $R1 $R0 1
		StrCmp $R1 "2" "" CustomCodePreInstallEnd
			IfFileExists "$INSTDIR\Data\profile\prefs.js" "" CustomCodePreInstallEnd
				FileOpen $0 "$INSTDIR\Data\profile\prefs.js" a
				FileSeek $0 0 END
				FileWriteByte $0 "13"
				FileWriteByte $0 "10"
				FileWrite $0 `user_pref("browser.cache.disk.capacity", 0);`
				FileWriteByte $0 "13"
				FileWriteByte $0 "10"
				FileClose $0 

	CustomCodePreInstallEnd:
!macroend

!macro CustomCodePostInstall
	CreateDirectory "$INSTDIR\Data\settings"
	WriteINIStr "$INSTDIR\Data\settings\ThunderbirdPortableSettings.ini" "ThunderbirdPortableSettings" "AgreedToLicense" "YES"
	
	StrCpy $R0 "$INSTDIR\Data\profile\mimeTypes.rdf"
	IfFileExists $R0 "" CustomCodePostInstallEnd
		${GetSize} "$INSTDIR\Data\profile" "/M=mimeTypes.rdf /S=0K /G=0" $1 $2 $3
		IntCmp $1 1024 CustomCodePostInstallEnd CustomCodePostInstallEnd
			Delete "$INSTDIR\Data\profile\mimeTypes.rdf"
	CustomCodePostInstallEnd:	
!macroend