${SegmentFile}

${SegmentPreExecPrimary}

	ReadINIStr $0 "$EXEDIR\App\Synkron\Synkron.ini" "General" "temp_path"
	StrCpy $1 "$0" 2
	${If} $1 == $CurrentDrive ; only replace if file is on current drive
		${WordReplace} $0 / \ + $1
		StrCpy $0 "$1\.backup.syncdb"
		${IfNot} $LastDirectory == $CurrentDirectory
			StrCpy $1 "$LastDirectory"
			${WordReplace} $1 \ / + $1
			StrCpy $2 "$CurrentDirectory"
			${WordReplace} $2 \ / + $2
			${ReplaceInFile} '$0' '$LastDrive$1' '$CurrentDrive$2'
		${EndIf}
		${IfNot} $LastDrive == $CurrentDrive
			${ReplaceInFile} '$0' '$LastDrive/' '$CurrentDrive/'
		${EndIf}
	${EndIf}

!macroend