${SegmentFile}

${SegmentPre}
	ExpandEnvStrings $1 "%PAL:LastPortableAppsBaseDir:ForwardSlash%"
	${WordReplace} $1 " " "%20" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LastPortableAppsBaseDir:CustomForwardSlash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:PortableAppsBaseDir:ForwardSlash%"
	${WordReplace} $1 " " "%20" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:PortableAppsBaseDir:CustomForwardSlash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:LastPackagePartialDir:ForwardSlash%"
	${WordReplace} $1 " " "%20" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LastPackagePartialDir:CustomForwardSlash", "$2").r0'
	
	ExpandEnvStrings $1 "%PAL:PackagePartialDir:ForwardSlash%"
	${WordReplace} $1 " " "%20" "+" $2
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:PackagePartialDir:CustomForwardSlash", "$2").r0'
!macroend