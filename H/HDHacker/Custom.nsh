${SegmentFile}

${SegmentPrePrimary}
    Delete "$EXEDIR\App\HDHacker\*.lng"
    ReadEnvStr $0 PAL:LanguageCustom
    ${If} ${FileExists} "$EXEDIR\App\HDHacker\Languages\$0.lng"
        CopyFiles /SILENT "$EXEDIR\App\HDHacker\Languages\$0.lng" "$EXEDIR\App\HDHacker\"
        Rename "$EXEDIR\App\HDHacker\$0.lng" "$EXEDIR\App\HDHacker\HDHacker.lng"
    ${EndIf}
!macroend
