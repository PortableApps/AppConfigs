${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	Delete "$EXEDIR\App\MicroSIP\langpack*.txt"
	${If} ${FileExists} "$EXEDIR\App\MicroSIP\langpacks\langpack_$0.txt"
		CopyFiles /SILENT "$EXEDIR\App\MicroSIP\langpacks\langpack_$0.txt" "$EXEDIR\App\MicroSIP\"

	${EndIf}
!macroend