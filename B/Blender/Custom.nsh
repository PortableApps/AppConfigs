${SegmentFile}

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

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Blender64
		Rename "$EXEDIR\App\Blender\2.78\datafiles" "$EXEDIR\App\Blender64\2.78\datafiles"
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Blender
		Rename "$EXEDIR\App\Blender64\2.78\datafiles" "$EXEDIR\App\Blender\2.78\datafiles"
    ${EndIf}
!macroend
