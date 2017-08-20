${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	Delete "$EXEDIR\App\miranda\langpack_*.txt"
	${If} $0 != "English"
		CopyFiles /SILENT "$EXEDIR\App\miranda\langpacks\langpack_$0.txt" "$EXEDIR\App\miranda\"
	${EndIf}
!macroend