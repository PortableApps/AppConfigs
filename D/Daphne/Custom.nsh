${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Daphne64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Daphne
    ${EndIf}
!macroend
