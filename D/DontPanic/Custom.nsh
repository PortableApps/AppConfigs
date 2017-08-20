${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\DontPanic\DontPanic64.exe"
			Rename "$EXEDIR\App\DontPanic\DontPanic.exe" "$EXEDIR\App\DontPanic\DontPanic32.exe"
			Rename "$EXEDIR\App\DontPanic\DontPanic64.exe" "$EXEDIR\App\DontPanic\DontPanic.exe"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\DontPanic\DontPanic32.exe"
			Rename "$EXEDIR\App\DontPanic\DontPanic.exe" "$EXEDIR\App\DontPanic\DontPanic64.exe"
			Rename "$EXEDIR\App\DontPanic\DontPanic32.exe" "$EXEDIR\App\DontPanic\DontPanic.exe"
		${EndIf}
	${EndIf}
!macroend