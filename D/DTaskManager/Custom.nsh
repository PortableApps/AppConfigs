${SegmentFile}

${SegmentPrePrimary}
    Delete "$EXEDIR\App\DTaskManager\*.lng"
    ReadEnvStr $0 PAL:LanguageCustom
    ${If} ${FileExists} "$EXEDIR\App\DTaskManager\Languages\$0.lng"
        CopyFiles /SILENT "$EXEDIR\App\DTaskManager\Languages\$0.lng" "$EXEDIR\App\DTaskManager\"
        Rename "$EXEDIR\App\DTaskManager\$0.lng" "$EXEDIR\App\DTaskManager\DTaskManager.lng"
    ${EndIf}
!macroend
