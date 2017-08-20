${OverrideExecute}

	StrCpy $1 `"$AppDirectory\$ProgramExecutable"`

	; Get command line arguments from the launcher INI file.
	ClearErrors
	${ReadLauncherConfig} $0 Launch CommandLineArguments
	${IfNot} ${Errors}
		${DebugMsg} "There are default command line arguments ($0).  Adding them to execution string after parsing."
		${ParseLocations} $0
		StrCpy $1 "$1 $0"
	${EndIf}
    
    ; Get command line parameters that were passed directly
	${GetParameters} $0
	StrCmp $0 "" LaunchWithoutParameters LaunchWithParameters
	
	LaunchWithoutParameters:
		SetOutPath $EXEDIR\App\toucan
		ExecShell "open" $1 "" SW_HIDE
		Goto TheEnd

	LaunchWithParameters:
		SetOutPath $EXEDIR
		ExecShell "open" $1 "$0"
        
    TheEnd:
        
!macroend