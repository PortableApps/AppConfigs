!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.2.9.9" $R0
		${If} $R0 == 2
			${If} ${FileExists} "$INSTDIR\App\Mumble\Overlay\*.*"
				Rename "$INSTDIR\App\Mumble\Overlay" "$INSTDIR\Data\Overlay"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Plugins\*.*"
				Rename "$INSTDIR\App\Mumble\Plugins" "$INSTDIR\Data\Plugins"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Snapshots\*.*"
				Rename "$INSTDIR\App\Mumble\Snapshots" "$INSTDIR\Data\Snapshots"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\Mumble\Themes\*.*"
				Rename "$INSTDIR\App\Mumble\Themes" "$INSTDIR\Data\Themes"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend
