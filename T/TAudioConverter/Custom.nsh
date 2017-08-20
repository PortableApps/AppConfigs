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
		${If} ${FileExists} "$EXEDIR\App\tac_64\Tools\flac.exe"
			Rename "$EXEDIR\App\tac\TAudioConverter.exe" "$EXEDIR\App\tac_32\TAudioConverter.exe"
			Rename "$EXEDIR\App\tac_64\TAudioConverter.exe" "$EXEDIR\App\tac\TAudioConverter.exe"	
			
			Rename "$EXEDIR\App\tac\Tools\flac.exe" "$EXEDIR\App\tac_32\Tools\flac.exe"
			Rename "$EXEDIR\App\tac_64\Tools\flac.exe" "$EXEDIR\App\tac\Tools\flac.exe"
			Rename "$EXEDIR\App\tac\Tools\lame.exe" "$EXEDIR\App\tac_32\Tools\lame.exe"
			Rename "$EXEDIR\App\tac_64\Tools\lame.exe" "$EXEDIR\App\tac\Tools\lame.exe"
			Rename "$EXEDIR\App\tac\Tools\metaflac.exe" "$EXEDIR\App\tac_32\Tools\metaflac.exe"
			Rename "$EXEDIR\App\tac_64\Tools\metaflac.exe" "$EXEDIR\App\tac\Tools\metaflac.exe"
			Rename "$EXEDIR\App\tac\Tools\oggenc2.exe" "$EXEDIR\App\tac_32\Tools\oggenc2.exe"
			Rename "$EXEDIR\App\tac_64\Tools\oggenc2.exe" "$EXEDIR\App\tac\Tools\oggenc2.exe"
			Rename "$EXEDIR\App\tac\Tools\opusenc.exe" "$EXEDIR\App\tac_32\Tools\opusenc.exe"
			Rename "$EXEDIR\App\tac_64\Tools\opusenc.exe" "$EXEDIR\App\tac\Tools\opusenc.exe"
			Rename "$EXEDIR\App\tac\Tools\ffmpeg" "$EXEDIR\App\tac_32\Tools\ffmpeg"
			Rename "$EXEDIR\App\tac_64\Tools\ffmpeg" "$EXEDIR\App\tac\Tools\ffmpeg"
			Rename "$EXEDIR\App\tac\Tools\lossyWAV" "$EXEDIR\App\tac_32\Tools\lossyWAV"
			Rename "$EXEDIR\App\tac_64\Tools\lossyWAV" "$EXEDIR\App\tac\Tools\lossyWAV"
			Rename "$EXEDIR\App\tac\Tools\mpc" "$EXEDIR\App\tac_32\Tools\mpc"
			Rename "$EXEDIR\App\tac_64\Tools\mpc" "$EXEDIR\App\tac\Tools\mpc"
			Rename "$EXEDIR\App\tac\Tools\qaac" "$EXEDIR\App\tac_32\Tools\qaac"
			Rename "$EXEDIR\App\tac_64\Tools\qaac" "$EXEDIR\App\tac\Tools\qaac"
			Rename "$EXEDIR\App\tac\Tools\sox" "$EXEDIR\App\tac_32\Tools\sox"
			Rename "$EXEDIR\App\tac_64\Tools\sox" "$EXEDIR\App\tac\Tools\sox"
			Rename "$EXEDIR\App\tac\Tools\wavpack" "$EXEDIR\App\tac_32\Tools\wavpack"
			Rename "$EXEDIR\App\tac_64\Tools\wavpack" "$EXEDIR\App\tac\Tools\wavpack"
			Rename "$EXEDIR\App\tac\Tools\WMAEncode" "$EXEDIR\App\tac_32\Tools\WMAEncode"
			Rename "$EXEDIR\App\tac_64\Tools\WMAEncode" "$EXEDIR\App\tac\Tools\WMAEncode"
		${EndIf}
    ${Else}
        ${If} ${FileExists} "$EXEDIR\App\tac_32\Tools\flac.exe"		
			Rename "$EXEDIR\App\tac\TAudioConverter.exe" "$EXEDIR\App\tac_64\TAudioConverter.exe"
			Rename "$EXEDIR\App\tac_32\TAudioConverter.exe" "$EXEDIR\App\tac\TAudioConverter.exe"		
		
			Rename "$EXEDIR\App\tac\Tools\flac.exe" "$EXEDIR\App\tac_64\Tools\flac.exe"
			Rename "$EXEDIR\App\tac_32\Tools\flac.exe" "$EXEDIR\App\tac\Tools\flac.exe"
			Rename "$EXEDIR\App\tac\Tools\lame.exe" "$EXEDIR\App\tac_64\Tools\lame.exe"
			Rename "$EXEDIR\App\tac_32\Tools\lame.exe" "$EXEDIR\App\tac\Tools\lame.exe"
			Rename "$EXEDIR\App\tac\Tools\metaflac.exe" "$EXEDIR\App\tac_64\Tools\metaflac.exe"
			Rename "$EXEDIR\App\tac_32\Tools\metaflac.exe" "$EXEDIR\App\tac\Tools\metaflac.exe"
			Rename "$EXEDIR\App\tac\Tools\oggenc2.exe" "$EXEDIR\App\tac_64\Tools\oggenc2.exe"
			Rename "$EXEDIR\App\tac_32\Tools\oggenc2.exe" "$EXEDIR\App\tac\Tools\oggenc2.exe"
			Rename "$EXEDIR\App\tac\Tools\opusenc.exe" "$EXEDIR\App\tac_64\Tools\opusenc.exe"
			Rename "$EXEDIR\App\tac_32\Tools\opusenc.exe" "$EXEDIR\App\tac\Tools\opusenc.exe"
			Rename "$EXEDIR\App\tac\Tools\ffmpeg" "$EXEDIR\App\tac_64\Tools\ffmpeg"
			Rename "$EXEDIR\App\tac_32\Tools\ffmpeg" "$EXEDIR\App\tac\Tools\ffmpeg"
			Rename "$EXEDIR\App\tac\Tools\lossyWAV" "$EXEDIR\App\tac_64\Tools\lossyWAV"
			Rename "$EXEDIR\App\tac_32\Tools\lossyWAV" "$EXEDIR\App\tac\Tools\lossyWAV"
			Rename "$EXEDIR\App\tac\Tools\mpc" "$EXEDIR\App\tac_64\Tools\mpc"
			Rename "$EXEDIR\App\tac_32\Tools\mpc" "$EXEDIR\App\tac\Tools\mpc"
			Rename "$EXEDIR\App\tac\Tools\qaac" "$EXEDIR\App\tac_64\Tools\qaac"
			Rename "$EXEDIR\App\tac_32\Tools\qaac" "$EXEDIR\App\tac\Tools\qaac"
			Rename "$EXEDIR\App\tac\Tools\sox" "$EXEDIR\App\tac_64\Tools\sox"
			Rename "$EXEDIR\App\tac_32\Tools\sox" "$EXEDIR\App\tac\Tools\sox"
			Rename "$EXEDIR\App\tac\Tools\wavpack" "$EXEDIR\App\tac_64\Tools\wavpack"
			Rename "$EXEDIR\App\tac_32\Tools\wavpack" "$EXEDIR\App\tac\Tools\wavpack"
			Rename "$EXEDIR\App\tac\Tools\WMAEncode" "$EXEDIR\App\tac_64\Tools\WMAEncode"
			Rename "$EXEDIR\App\tac_32\Tools\WMAEncode" "$EXEDIR\App\tac\Tools\WMAEncode"
		${EndIf}
    ${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comDocuments%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		${GetParent} $EXEDIR $3
		${GetParent} $3 $1
		${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $3
		${EndIf}
		${If} ${FileExists} "$1\Documents\*.*"
			StrCpy $2 "$1\Documents"
		${Else}
			${GetRoot} $EXEDIR $1
			${If} ${FileExists} "$1\Documents\*.*"
				StrCpy $2 "$1\Documents"
			${Else}
				StrCpy $2 "$1"
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDocuments", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comMusic%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Music\*.*"
			StrCpy $2 "$1\Music"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Music\*.*"
				StrCpy $2 "$1\Music"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Music\*.*"
					StrCpy $2 "$1\Music"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comMusic", "$2").r0'
	${EndIf}
!macroend
