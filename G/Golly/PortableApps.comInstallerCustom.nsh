!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.4.0.1" $1
		${If} $1 == 2 ;Upgrading from version before 2.4.0.1
		${AndIf} ${FileExists} "$INSTDIR\Data\GollyPrefs"
			${ConfigWrite} "$INSTDIR\Data\GollyPrefs" "user_rules=" "DEFAULTGOLLYPORTABLEDATAPATH\Rules\" $R0
			${ConfigWrite} "$INSTDIR\Data\GollyPrefs" "download_dir=" "DEFAULTGOLLYPORTABLEDATAPATH\Downloads\" $R0
			CreateDirectory "$INSTDIR\Data\Rules"
			CreateDirectory "$INSTDIR\Data\Downloads"
			CreateDirectory "$INSTDIR\Data\settings"
			Delete "$INSTDIR\Data\GollyPortInfo.ini"
		${EndIf}
	${EndIf}
!macroend