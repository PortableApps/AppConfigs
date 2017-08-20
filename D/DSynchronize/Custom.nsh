${SegmentFile}

${SegmentPrePrimary}
    Delete "$EXEDIR\App\DSynchronize\*.lng"
    ReadEnvStr $0 PAL:LanguageCustom
    ${If} ${FileExists} "$EXEDIR\App\DSynchronize\Languages\$0.lng"
        CopyFiles /SILENT "$EXEDIR\App\DSynchronize\Languages\$0.lng" "$EXEDIR\App\DSynchronize\"
        Rename "$EXEDIR\App\DSynchronize\$0.lng" "$EXEDIR\App\DSynchronize\DSynchronize.lng"
    ${EndIf}
!macroend
