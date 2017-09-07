${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\AkelPadx64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\AkelPad
    ${EndIf}
!macroend
