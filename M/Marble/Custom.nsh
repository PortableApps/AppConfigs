${SegmentFile}

${SegmentPrePrimary}
    ${If} ${FileExists} $DataDirectory\settings\.marble
        Rename $DataDirectory\settings\.marble $DataDirectory\.marble
    ${EndIf}
!macroend
