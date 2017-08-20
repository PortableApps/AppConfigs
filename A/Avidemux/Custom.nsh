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
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Avidemux64"
	${Else}
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Avidemux32"
	${EndIf}
!macroend

${SegmentPre}
	ExpandEnvStrings $1 "%PAL:LastPortableAppsBaseDir%"
	${WordReplace} $1 "\" "\/" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LastPortableAppsBaseDir:EscapedForwardSlash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:PortableAppsBaseDir%"
	${WordReplace} $1 "\" "\/" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:PortableAppsBaseDir:EscapedForwardSlash", "$2").r0'
	
		ExpandEnvStrings $1 "%PAL:LastPackagePartialDir%"
	${WordReplace} $1 "\" "\/" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LastPackagePartialDir:EscapedForwardSlash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:PackagePartialDir%"
	${WordReplace} $1 "\" "\/" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:PackagePartialDir:EscapedForwardSlash", "$2").r0'
!macroend
