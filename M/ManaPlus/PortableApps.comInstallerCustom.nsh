!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.6.3.12" $1
		${If} $1 == 0 ;Upgrading from 1.6.3.12 which stores settings incorrectly
		${AndIf} ${FileExists} "$INSTDIR\App\TheManaWorld\configs\*.*"
			;Data is in the wrong place
			${If} ${FileExists} "$INSTDIR\Data\settings\config.xml"
				;There are two different settings sets, move the older one
				CreateDirectory "$INSTDIR\Data\OlderSettings"
				Rename "$INSTDIR\Data\settings" "$INSTDIR\Data\OlderSettings\settings"
				CreateDirectory "$INSTDIR\Data\settings"
				Rename "$INSTDIR\Data\OlderSettings\settings\TheManaWorldPortableSettings.ini" "$INSTDIR\Data\settings\TheManaWorldPortableSettings.ini"
				Rename "$INSTDIR\Data\screenshots" "$INSTDIR\Data\OlderSettings\screenshots"
			${EndIf}
			;Move the current settings to the proper locations
			Rename "$INSTDIR\App\TheManaWorld\screenshots" "$INSTDIR\Data\screenshots"
			Rename "$INSTDIR\App\TheManaWorld\logs\temp" "$INSTDIR\Data\settings\temp"
			CopyFiles /SILENT "$INSTDIR\App\TheManaWorld\logs\*.*" "$INSTDIR\Data\settings"
			RMDir /r "$INSTDIR\App\TheManaWorld\logs"
			CopyFiles /SILENT "$INSTDIR\App\TheManaWorld\configs\*.*" "$INSTDIR\Data\settings"
			RMDir /r "$INSTDIR\App\TheManaWorld\configs"
		${EndIf}
	${EndIf}
!macroend