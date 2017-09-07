${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Listary\X64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Listary\Win32
    ${EndIf}
!macroend
