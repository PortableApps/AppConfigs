!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $1 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$1" "5.0.6.0" $2
		${If} $2 == "2" ;then upgrading from pre-5.0.6
		${AndIf} ${FileExists} "$INSTDIR\Data\options\guiopts.lua"
			${ConfigWrite} "$INSTDIR\Data\options\guiopts.lua" "log_file_path = " '".\\..\\..\\..\\Data\\UltraDefragPortable.log"' $R0
		${EndIf}
		${VersionCompare} "$1" "7.1.2.0" $2
		${If} $2 == "2" ;then upgrading from pre-7.1.2
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\gui.ini"
			WriteINIStr "$INSTDIR\Data\settings\gui.ini" "Upgrade" "Level" "0"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${IfNot} ${FileExists} "$INSTDIR\Data\settings\options.lua"
	${AndIf} ${FileExists} "$INSTDIR\Data\options\*.*"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\options.lua" "$INSTDIR\Data\settings"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\gui.ini" "$INSTDIR\Data\settings"
	${EndIf}
!macroend
