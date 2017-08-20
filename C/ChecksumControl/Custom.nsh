${SegmentFile}

Var CC64
Var CC

${Segment.OnInit}
	; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0
		StrCpy $Bits 32
	${Else}
		StrCpy $Bits 64
	${EndIf}
!macroend

${SegmentPre}
    ${If} $Bits = 64
		StrCpy $CC64 ChecksumControl64
        ${SetEnvironmentVariablesPath} CCbits $CC64
    ${Else}
		StrCpy $CC ChecksumControl
        ${SetEnvironmentVariablesPath} CCbits $CC
    ${EndIf}
!macroend

${SegmentPreExec}
	${If} $Bits = 64
		Rename $LOCALAPPDATA\ChecksumControl64\ChecksumControl.cfg $LOCALAPPDATA\ChecksumControl64\ChecksumControl64.cfg
	${EndIf}
!macroend

${SegmentPostPrimary}
	${If} $Bits = 64
		Rename $EXEDIR\Data\ChecksumControl\ChecksumControl64.cfg $EXEDIR\Data\ChecksumControl\ChecksumControl.cfg
	${EndIf}
!macroend