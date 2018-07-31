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
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Krita64
		Rename "$EXEDIR\App\Krita\bin\locale" "$EXEDIR\App\Krita64\bin\locale"
		Rename "$EXEDIR\App\Krita\share" "$EXEDIR\App\Krita64\share"
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\Krita
		Rename "$EXEDIR\App\Krita64\bin\locale" "$EXEDIR\App\Krita\bin\locale"
		Rename "$EXEDIR\App\Krita64\share" "$EXEDIR\App\Krita\share"
    ${EndIf}
	
	;Ensure we have a proper Documents path
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
		
		${WordReplace} "$2" "\" "/" "+" $2
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDocuments:ForwardSlash", "$2").r0'
	${EndIf}
!macroend