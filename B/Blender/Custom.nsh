${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Blender64
		Rename "$EXEDIR\App\Blender\2.79\datafiles" "$EXEDIR\App\Blender64\2.79\datafiles"
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Blender
		Rename "$EXEDIR\App\Blender64\2.79\datafiles" "$EXEDIR\App\Blender\2.79\datafiles"
    ${EndIf}
!macroend
