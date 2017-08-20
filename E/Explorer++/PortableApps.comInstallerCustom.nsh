!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\x86\*.*"
		RMDir /r "$INSTDIR\Data\x86"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\x64\*.*"
		RMDir /r "$INSTDIR\Data\x64"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "1.2.9.9" $1
		${If} $1 == "2"  ;Prior to version 1.3
			RMDir /r "$INSTDIR\Data"
		${EndIf}
	${EndIf}
!macroend
