Var PreviousVersion

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $PreviousVersion "$INSTDIR\App\AppInfo\AppInfo.ini" "Version" "PackageVersion"
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${VersionCompare} "$PreviousVersion" "1.3.2.0" $1
	${If} $1 == "2"
	${AndIf} ${FileExists} "$INSTDIR\Data\"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\CCLP1.ccx" "$INSTDIR\Data\settings\data"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\CCLP1.dat" "$INSTDIR\Data\settings\data"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\CCLP2.dat" "$INSTDIR\Data\settings\data"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\CCLP3.ccx" "$INSTDIR\Data\settings\data"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\CCLP3.dat" "$INSTDIR\Data\settings\data"
	${Else}
	${EndIf}
!macroend