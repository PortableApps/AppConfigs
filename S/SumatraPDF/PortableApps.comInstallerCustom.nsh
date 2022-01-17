!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\SumatraPDF\sumatrapdfcache\*.*"
		Rename "$INSTDIR\App\SumatraPDF\sumatrapdfcache" "$INSTDIR\Data\settings\sumatrapdfcache"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\SumatraPDF\SumatraPDF-settings.txt"
		Rename "$INSTDIR\App\SumatraPDF\SumatraPDF-settings.txt" "$INSTDIR\Data\settings\SumatraPDF-settings.txt"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\SumatraPDF\sumatrapdfprefs.dat"
		Rename "$INSTDIR\App\SumatraPDF\sumatrapdfprefs.dat" "$INSTDIR\Data\settings\sumatrapdfprefs.dat"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\sumatrapdfcache\*.*"
		Rename "$INSTDIR\Data\sumatrapdfcache" "$INSTDIR\Data\settings\sumatrapdfcache"
	${EndIf}
!macroend
