${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\WinMTR64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\WinMTR
    ${EndIf}
!macroend
