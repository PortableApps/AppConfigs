!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "2.19.6.0" $R0
		${If} $R0 == "2"
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\coolplayer.ini"
			WriteINIStr "$INSTDIR\Data\settings\coolplayer.ini" "Skin" "SkinFile1" "$INSTDIR\App\CoolPlayer+\CoolPlayer+PortableSkin\CoolPlayer+Portable.ini"
			WriteINIStr "$INSTDIR\Data\settings\coolplayer.ini" "Skin" "SkinFile2" "$INSTDIR\App\CoolPlayer+\CoolPlayer+PortableSkin\CoolPlayer+Portable_EQ.ini"
			WriteINIStr "$INSTDIR\Data\settings\coolplayer.ini" "Skin" "SkinFile3" "$INSTDIR\App\CoolPlayer+\CoolPlayer+PortableSkin\CoolPlayer+Portable_shade.ini"
		${EndIf}
	${EndIf}
!macroend
