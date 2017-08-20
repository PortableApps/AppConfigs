${SegmentFile}

${SegmentPrePrimary}
	${If} ${AtLeastWinVista}
		${If} ${FileExists} "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll.disabled"
			Rename "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll.disabled" "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll"
			Rename "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll" "$EXEDIR\App\QupZilla\D3Dcompiler_47.dll.disabled"
		${EndIf}
	${EndIf}
!macroend
