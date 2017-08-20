!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\*.*"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\Recordings\*.*"
		CreateDirectory "$INSTDIR\Data\Recordings"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\CamStudio\*.avi"
		CopyFiles /SILENT "$INSTDIR\App\CamStudio\*.avi" "$INSTDIR\Data\Recordings"
		Delete "$INSTDIR\App\CamStudio\*.avi"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\CamStudio\*.swf"
		CopyFiles /SILENT "$INSTDIR\App\CamStudio\*.swf" "$INSTDIR\Data\Recordings"
		Delete "$INSTDIR\App\CamStudio\*.swf"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\CamStudio\Recordings\*.swf"
		CopyFiles /SILENT "$INSTDIR\App\CamStudio\Recordings\*.swf" "$INSTDIR\Data\Recordings"
		Delete "$INSTDIR\App\CamStudio\Recordings\*.swf"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\CamStudio\Recordings\*.avi"
		CopyFiles /SILENT "$INSTDIR\App\CamStudio\Recordings\*.avi" "$INSTDIR\Data\Recordings"
		Delete "$INSTDIR\App\CamStudio\Recordings\*.avi"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $1 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$1" "2.6.294.1" $2
		${If} $2 == "2" ;then upgrading from pre-2.6b r294 Rev 2
			WriteINIStr "$INSTDIR\Data\settings\CamStudio.ini" "CamStudio Settings ver2.50 -- Please do not edit" "specifieddir" "$INSTDIR\Data\Recordings"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\CamStudio.ini"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\settings\CamStudio.cfg"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\CamStudio.cfg" "$INSTDIR\Data\settings"
		${IfNot} ${FileExists} "$INSTDIR\Data\settings\CamStudio.Producer.Data.ini"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\CamStudio.Producer.Data.ini" "$INSTDIR\Data\settings"
		${EndIf}
		${IfNot} ${FileExists} "$INSTDIR\Data\settings\CamStudio.Producer.ini"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\CamStudio.Producer.ini" "$INSTDIR\Data\settings"
		${EndIf}
	${EndIf}
!macroend