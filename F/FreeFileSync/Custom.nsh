${SegmentFile}

${SegmentPre}

	${ReadUserConfig} $0 RealtimeSync
	${If} $0 == true
		StrCpy $ProgramExecutable "FreeFileSync\RealtimeSync.exe"
	${EndIf}

	${If} ${FileExists} $CurrentDrive$CurrentDirectory\$AppID.ini
		StrCpy $0 $CurrentDrive$CurrentDirectory\$AppID.ini
		${IfNot} $LastDirectory == $CurrentDirectory
			${ReplaceInFile} '$0' '$LastDrive$LastDirectory' '$CurrentDrive$CurrentDirectory'
		${EndIf}
		${IfNot} $LastDrive == $CurrentDrive
			${ReplaceInFile} '$0' '$LastDrive\' '$CurrentDrive\'
		${EndIf}
	${EndIf}

!macroend
