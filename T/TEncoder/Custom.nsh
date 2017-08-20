${SegmentFile}

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
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\TEncoder64
		Rename "$EXEDIR\App\TEncoder32\MEncoder\mplayer.exe" "$EXEDIR\App\TEncoder64\MEncoder\mplayer.exe"
		Rename "$EXEDIR\App\TEncoder32\MEncoder\mencoder.exe" "$EXEDIR\App\TEncoder64\MEncoder\mencoder.exe"
		Rename "$EXEDIR\App\TEncoder32\youtube-dl\youtube-dl.exe" "$EXEDIR\App\TEncoder64\youtube-dl\youtube-dl.exe"
		Rename "$EXEDIR\App\TEncoder32\MP4Box.exe" "$EXEDIR\App\TEncoder64\MP4Box.exe"
		Rename "$EXEDIR\App\TEncoder32\MEncoder\libiconv-2.dll" "$EXEDIR\App\TEncoder64\MEncoder\libiconv-2.dll"
		Rename "$EXEDIR\App\TEncoder32\MEncoder\xvidcore.dll" "$EXEDIR\App\TEncoder64\MEncoder\xvidcore.dll"
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\TEncoder32
		Rename "$EXEDIR\App\TEncoder64\MEncoder\mplayer.exe" "$EXEDIR\App\TEncoder32\MEncoder\mplayer.exe"
		Rename "$EXEDIR\App\TEncoder64\MEncoder\mencoder.exe" "$EXEDIR\App\TEncoder32\MEncoder\mencoder.exe"
		Rename "$EXEDIR\App\TEncoder64\youtube-dl\youtube-dl.exe" "$EXEDIR\App\TEncoder32\youtube-dl\youtube-dl.exe"
		Rename "$EXEDIR\App\TEncoder64\MP4Box.exe" "$EXEDIR\App\TEncoder32\MP4Box.exe"
		Rename "$EXEDIR\App\TEncoder64\MEncoder\libiconv-2.dll" "$EXEDIR\App\TEncoder32\MEncoder\libiconv-2.dll"
		Rename "$EXEDIR\App\TEncoder64\MEncoder\xvidcore.dll" "$EXEDIR\App\TEncoder32\MEncoder\xvidcore.dll"
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
	
	ExpandEnvStrings $1 "%PortableApps.comVideos%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Videos\*.*"
			StrCpy $2 "$1\Videos"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Videos\*.*"
				StrCpy $2 "$1\Videos"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Videos\*.*"
					StrCpy $2 "$1\Videos"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comVideos", "$2").r0'
	${EndIf}
!macroend
