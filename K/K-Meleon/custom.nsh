${SegmentFile}

${SegmentPre}
	ExpandEnvStrings $1 "%PAL:LastPortableAppsBaseDir%"
	${WordReplace} $1 "\" "\\\\" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LastPortableAppsBaseDir:QuadBackslash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:PortableAppsBaseDir%"
	${WordReplace} $1 "\" "\\\\" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:PortableAppsBaseDir:QuadBackslash", "$2").r0'
!macroend