${SegmentFile}

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
