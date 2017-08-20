${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	${If} ${FileExists} "$EXEDIR\Data\Config\nativeLang.xml"
		Delete "$EXEDIR\Data\Config\nativeLang.xml"
	${ElseIf} ${FileExists} "$EXEDIR\App\Notepad++\nativeLang.xml"
		Delete "$EXEDIR\App\Notepad++\nativeLang.xml"
	${EndIf}
	
	${If} $0 != "English"
		${If} ${FileExists} "$EXEDIR\App\Notepad++\localization\$0.xml"
			CopyFiles /SILENT "$EXEDIR\App\Notepad++\localization\$0.xml" "$EXEDIR\App\Notepad++\"
			Rename "$EXEDIR\App\Notepad++\$0.xml" "$EXEDIR\App\Notepad++\nativeLang.xml"
		${EndIf}
	${EndIf}
!macroend