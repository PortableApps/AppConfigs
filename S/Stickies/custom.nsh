${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	${If} $0 == "English"
		Delete "$EXEDIR\App\stickies\language90.dll"
	${Else}
		${If} ${FileExists} "$EXEDIR\App\stickies\Languages\$0\language90.dll"
			Delete "$EXEDIR\App\stickies\language90.dll"
			CopyFiles /SILENT "$EXEDIR\App\stickies\Languages\$0\language90.dll" "$EXEDIR\App\stickies\"
		${EndIf}
	${EndIf}
!macroend
${SegmentPreExecPrimary}
	ClearErrors
	ReadINIStr $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
	${If} ${Errors}
		StrCpy $0 "0.0.0.1"
		ClearErrors
	${EndIf}
	
	ClearErrors
	ReadINIStr $1 "$EXEDIR\Data\settings\StickiesPortableSettings.ini" "StickiesPortableSettings" "LastHelpFileFrom"
	${If} ${Errors}
		StrCpy $1 "0.0.0.0"
		ClearErrors
	${EndIf}
	
	${VersionCompare} $0 $1 $2
	
	${If} $2 == 1
		;Update the help file
		Delete "$EXEDIR\Data\stickies.chm"
		CopyFiles /SILENT "$EXEDIR\App\Stickies\stickies.chm" "$EXEDIR\Data"
		WriteINIStr "$EXEDIR\Data\settings\StickiesPortableSettings.ini" "StickiesPortableSettings" "LastHelpFileFrom" $0
	${EndIf}
!macroend