${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	Delete "$EXEDIR\App\mirandang\langpack_*.txt"
	${If} $0 != "English"
		CopyFiles /SILENT "$EXEDIR\App\langpacks\langpack_$0.txt" "$EXEDIR\App\mirandang\"
	${EndIf}
!macroend