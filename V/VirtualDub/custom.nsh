${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\VirtualDub64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\VirtualDub
    ${EndIf}
!macroend
