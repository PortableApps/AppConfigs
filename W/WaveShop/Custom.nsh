${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\WaveShop64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\WaveShop
    ${EndIf}
!macroend
