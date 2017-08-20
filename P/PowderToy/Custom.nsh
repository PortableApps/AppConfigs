!define PF_XMMI64_INSTRUCTIONS_AVAILABLE 10

${SegmentFile}

${SegmentInit}
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0

	${If} $0 == 0
		;SSE2 unavailable
		MessageBox MB_ICONEXCLAMATION|MB_OK "This computer has an older CPU that lacks SSE2 instruction set support. The Powder Toy may not function on this computer."
	${EndIf}
!macroend
