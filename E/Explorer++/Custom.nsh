${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\Explorer++\Explorer++64.exe"
			Rename "$EXEDIR\App\Explorer++\Explorer++.exe" "$EXEDIR\App\Explorer++\Explorer++32.exe"
			Rename "$EXEDIR\App\Explorer++\Explorer++64.exe" "$EXEDIR\App\Explorer++\Explorer++.exe"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\Explorer++\Explorer++32.exe"
			Rename "$EXEDIR\App\Explorer++\Explorer++.exe" "$EXEDIR\App\Explorer++\Explorer++64.exe"
			Rename "$EXEDIR\App\Explorer++\Explorer++32.exe" "$EXEDIR\App\Explorer++\Explorer++.exe"
		${EndIf}
    ${EndIf}
!macroend
