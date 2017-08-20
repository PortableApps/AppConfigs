!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "0.4.12.801" $1
		${If} $1 == "2"  ;$0 is older than
			CreateDirectory "$INSTDIR\Data\lmms"
			CopyFiles /SILENT "$INSTDIR\Data\settings\lmms\*.*" "$INSTDIR\Data\lmms"
			RMDir /r "$INSTDIR\Data\settings\lmms"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${IfNot} ${FileExists} "$INSTDIR\Data\.lmmsrc.xml"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\.lmmsrc.xml" "$INSTDIR\Data\.lmmsrc.xml"
	${EndIf}
!macroend