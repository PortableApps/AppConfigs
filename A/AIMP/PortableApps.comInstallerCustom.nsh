!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\*.*"
		CreateDirectory "$INSTDIR\Data\Recorded"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\Profile\AIMP3.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${If} $0 == "3.10.1074.2"
			WriteINIStr "$INSTDIR\Data\Profile\AIMP3.ini" "PlsSettings" "SaveAbsoluteFileNames" "0"
		${EndIf}
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "4.0.0.0" $R0
		${If} $R0 == 2
		${AndIf} ${FileExists} "$INSTDIR\Data\Profile\AIMP3.ini"
			CreateDirectory "$INSTDIR\Data\Profile3Backup"
			CopyFiles /SILENT "$INSTDIR\Data\Profile\*.*" "$INSTDIR\Data\Profile3Backup"
			Rename "$INSTDIR\Data\AIMP3.ini" "$INSTDIR\Data\AIMP.ini"
			Rename "$INSTDIR\Data\Profile\AIMP3.bak" "$INSTDIR\Data\Profile\AIMP.bak"
			Rename "$INSTDIR\Data\Profile\AIMP3.ini" "$INSTDIR\Data\Profile\AIMP.ini"
			Rename "$INSTDIR\Data\Profile\AIMP3-SkinLayout.ini" "$INSTDIR\Data\Profile\AIMP-SkinLayout.ini"
			Rename "$INSTDIR\Data\Profile\aimp3_menu.ini" "$INSTDIR\Data\Profile\AIMP-ContextMenu.ini"
			Rename "$INSTDIR\Data\Profile\AIMP3ac.ini" "$INSTDIR\Data\Profile\AIMPac.ini"
			Rename "$INSTDIR\Data\Profile\AIMP3-cat.db" "$INSTDIR\Data\Profile\AIMP-cat.db"
			Rename "$INSTDIR\Data\Profile\AIMP3lib.bak" "$INSTDIR\Data\Profile\AIMPlib.bak"
			Rename "$INSTDIR\Data\Profile\AIMP3lib.ini" "$INSTDIR\Data\Profile\AIMPlib.ini"
			Rename "$INSTDIR\Data\Profile\AudioLibrary\AIMP3.db" "$INSTDIR\Data\Profile\AudioLibrary\Local.db"
			Rename "$INSTDIR\Data\Profile\AudioLibrary\AIMP3-DataViews.db" "$INSTDIR\Data\Profile\AudioLibrary\Local-DataViews.db"
		${EndIf}
	${EndIf}
!macroend
