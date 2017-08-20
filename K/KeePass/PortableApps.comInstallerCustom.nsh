!macro CustomCodePreInstall
	;Move KDBs out of root so they are not accidentally deleted later
	${If} ${FileExists} "$INSTDIR\*.kdb"
		${If} ${FileExists} "$INSTDIR\Data\*.kdb"
			CreateDirectory "$INSTDIR\Data\KDBs"
			CopyFiles /SILENT "$INSTDIR\*.kdb" "$INSTDIR\Data\KDBs"
		${Else}
			CreateDirectory "$INSTDIR\Data"
			CopyFiles /SILENT "$INSTDIR\*.kdb" "$INSTDIR\Data"
		${EndIf}
		Delete "$INSTDIR\*.kdb"
	${EndIf}
!macroend