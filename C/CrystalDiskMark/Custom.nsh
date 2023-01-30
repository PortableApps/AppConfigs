${SegmentFile}

${Segment.OnInit}
	;Fix from earlier version of settings
	Rename "$EXEDIR\Data\DiskMarkX64.ini" "$EXEDIR\Data\DiskMark64.ini"
	Rename "$EXEDIR\Data\DiskMark.ini" "$EXEDIR\Data\DiskMark32.ini"


	ReadRegStr $0 HKLM "HARDWARE\DESCRIPTION\System" "Identifier"
	StrCpy $1 $0 3 0
		
	${If} $1 == "ARM"
		Rename "$EXEDIR\Data\DiskMark64.ini" "$EXEDIR\Data\DiskMarkA64.ini"
		Rename "$EXEDIR\Data\DiskMark32.ini" "$EXEDIR\Data\DiskMarkA64.ini"
	${Else}
		; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
		System::Call kernel32::GetCurrentProcess()i.s
		System::Call kernel32::IsWow64Process(is,*i.r0)
		${If} $0 == 0
			;32
			Rename "$EXEDIR\Data\DiskMark64.ini" "$EXEDIR\Data\DiskMark32.ini"
			Rename "$EXEDIR\Data\DiskMarkA64.ini" "$EXEDIR\Data\DiskMark32.ini"
		${Else}
			;64
			Rename "$EXEDIR\Data\DiskMark32.ini" "$EXEDIR\Data\DiskMark64.ini"
			Rename "$EXEDIR\Data\DiskMarkA64.ini" "$EXEDIR\Data\DiskMark64.ini"
		${EndIf}
	${EndIf}
!macroend

${SegmentPre}
	ReadRegStr $0 HKLM "HARDWARE\DESCRIPTION\System" "Identifier"
	StrCpy $1 $0 3 0
		
	${If} $1 == "ARM"
		${ReadLauncherConfig} $ProgramExecutable Launch ProgramExecutableARM64
	${EndIf}
!macroend