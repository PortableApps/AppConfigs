${SegmentFile}

Var CustomLastDocumentsDirectory

${SegmentPrePrimary}
	; Get the last documents directory
	ReadINIStr $CustomLastDocumentsDirectory $EXEDIR\Data\settings\PasswordSafePortableSettings.ini PasswordSafePortableSettings LastDocumentsDirectory
	
	${If} $CustomLastDocumentsDirectory == ""
		StrCpy $CustomLastDocumentsDirectory "??????????NonsenseString??????????"
	${EndIf}

	StrCpy $0 $CustomLastDocumentsDirectory
	${SetEnvironmentVariable} CustomLastDocumentsDirectory $0
	
	ExpandEnvStrings $0 "$DOCUMENTS"
	
	; Store current documents directory for next time
	WriteINIStr $EXEDIR\Data\settings\PasswordSafePortableSettings.ini PasswordSafePortableSettings LastDocumentsDirectory $0
!macroend
