!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "3.15.3.0" $1
		${If} $1 == 2
			${If} ${FileExists} "$INSTDIR\App\MicroSIP\Contacts.xml"
				${If} ${FileExists} "$INSTDIR\Data\Contacts.xml"
					Rename "$INSTDIR\Data\Contacts.xml" "$INSTDIR\Data\Contacts-backup.xml"
				${EndIf}
				Rename "$INSTDIR\App\MicroSIP\Contacts.xml" "$INSTDIR\Data\Contacts.xml"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\MicroSIP\MicroSIP.log"
				${If} ${FileExists} "$INSTDIR\Data\MicroSIP.log"
					Rename "$INSTDIR\Data\MicroSIP.log" "$INSTDIR\Data\MicroSIP-backup.log"
				${EndIf}
				Rename "$INSTDIR\App\MicroSIP\MicroSIP.log" "$INSTDIR\Data\MicroSIP.log"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\MicroSIP\MicroSIP.ini"
				${If} ${FileExists} "$INSTDIR\Data\MicroSIP.ini"
					Rename "$INSTDIR\Data\MicroSIP.ini" "$INSTDIR\Data\MicroSIP-backup.ini"
				${EndIf}
				Rename "$INSTDIR\App\MicroSIP\MicroSIP.ini" "$INSTDIR\Data\MicroSIP.ini"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend