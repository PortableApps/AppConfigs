!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "12.99.99.99" $R0
		${If} $R0 == "2"
			${GetParent} $INSTDIR $0
			${IfNot} ${FileExists} "$0\OperaPortableLegacy12\App\AppInfo\appinfo.ini"
				CreateDirectory "$0\OperaPortableLegacy12"
				CopyFiles /SILENT "$INSTDIR\*.*" "$0\OperaPortableLegacy12"
				WriteINIStr "$0\OperaPortableLegacy12\App\AppInfo\appinfo.ini" "Details" "Name" "Opera, Portable Edition Legacy"
				WriteINIStr "$0\OperaPortableLegacy12\App\AppInfo\appinfo.ini" "Details" "AppID" "OperaPortableLegacy12"
			${Else}
				Rename "$INSTDIR\Data\profile-12.x" "$INSTDIR\Data\profile-12.x-old"
				CreateDirectory "$INSTDIR\Data\profile-12.x"
				CopyFiles /SILENT "$INSTDIR\Data\profile\*.*" "$INSTDIR\Data\profile-12.x"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Opera\profile\operaprefs.ini"
				Rename "$INSTDIR\App\Opera\profile" "$INSTDIR\Data\profile-old-backup"
			${EndIf}
			RMDir /r "$INSTDIR\App\Opera\profile"
		${EndIf}
	${EndIf}
!macroend
