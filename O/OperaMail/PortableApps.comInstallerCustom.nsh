!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "11.9.99.0" $1
		${If} $1 == "2"  ;$0 is older than 11.10
			${IfNot} ${FileExists} "$INSTDIR\Data\profile\*.*"
			${AndIf} ${FileExists} "$INSTDIR\App\Opera\profile\*.*"
				;Move the profile to the proper location
				Rename "$INSTDIR\App\Opera\profile" "$INSTDIR\Data\profile"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend