${SegmentFile}

${SegmentPrePrimary}
	;=== Be sure the ComSpec environment variable is set right
	ReadEnvStr $R0 "COMSPEC"
	StrLen $0 $R0
	IntCmp $0 1 CreateComSpec CreateComSpec ContinueLaunch
		
	CreateComSpec:
		;=== We need to set the variable
		ReadEnvStr $R0 "SYSTEMROOT"
		IfFileExists "$R0\system32\cmd.exe" "" AltComSpecPath
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("COMSPEC", "$R0\system32\cmd.exe").r0'
		Goto ContinueLaunch

	AltComSpecPath:
		IfFileExists "$R0\command.com" "" NoComSpec
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("COMSPEC", "$R0\command.com").r0'
		Goto ContinueLaunch
	
	NoComSpec:
		StrCpy $MISSINGFILEORPATH `command.com/cmd.exe`
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	ContinueLaunch:
!macroend

${SegmentPost}
	Delete '$TEMP\ClamWin*.log'
	Delete '$TEMP\ClamWin*.txt'
	Delete '$TEMP\clamav-*.*'		
	Delete '$TEMP\ClamWin_Up*.*'
!macroend