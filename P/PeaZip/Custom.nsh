${SegmentFile}

${Segment.OnInit}
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0 ;32bit
		${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\PeaZip"
	${Else} ;64bit
		${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\PeaZip64"
	${EndIf}
!macroend

${SegmentInit}
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\share\*.*"
			Rename "$EXEDIR\App\PeaZip\res\share" "$EXEDIR\App\PeaZip64\res\share"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\PeaZip64\res\share\*.*"
			Rename "$EXEDIR\App\PeaZip64\res\share" "$EXEDIR\App\PeaZip\res\share"
		${EndIf}
    ${EndIf}
!macroend
