${SegmentFile}

${SegmentPrePrimary}
	;Our variable to store the last short language handled
	;This is used to ensure we don't handle en twice for both en_US and en_GB, for instance
	StrCpy $5 "??"

	;Ensure we have our directory for custom dictionaries
	CreateDirectory "$EXEDIR\Data\enchant"
	CreateDirectory "$LOCALAPPDATA\enchant"

	;Loop through included dictionaries
	FindFirst $0 $1 "$EXEDIR\App\Rednotebook\share\enchant\myspell\*.dic"
	${DoWhile} $1 != ""
		${GetBaseName} $1 $2
		;Backup existing custom dictionary files on the local machine that match dictionaries we may use
		Rename "$LOCALAPPDATA\enchant\$2.dic" "$LOCALAPPDATA\enchant\$2.dic-backupByRedNotebookPortable"
		Rename "$LOCALAPPDATA\enchant\$2.exc" "$LOCALAPPDATA\enchant\$2.ext-backupByRedNotebookPortable"
		
		;Copy our custom files if they exist
		${If} ${FileExists} "$EXEDIR\Data\enchant\$2.dic"
			CopyFiles /SILENT "$EXEDIR\Data\enchant\$2.dic" "$LOCALAPPDATA\enchant"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\enchant\$2.exc"
			CopyFiles /SILENT "$EXEDIR\Data\enchant\$2.exc" "$LOCALAPPDATA\enchant"
		${EndIf}
		
		;Determine if dealing with a compound locale like en_US and also handle en
		StrLen $3 $2
		StrCpy $4 $2 2
		${If} $3 > 2
		${AndIf} $4 != $5
			StrCpy $5 $4
			Rename "$LOCALAPPDATA\enchant\$4.dic" "$LOCALAPPDATA\enchant\$4.dic-backupByRedNotebookPortable"
			Rename "$LOCALAPPDATA\enchant\$4.exc" "$LOCALAPPDATA\enchant\$4.ext-backupByRedNotebookPortable"
			
			;Copy our custom files if they exist
			${If} ${FileExists} "$EXEDIR\Data\enchant\$4.dic"
				CopyFiles /SILENT "$EXEDIR\Data\enchant\$4.dic" "$LOCALAPPDATA\enchant"
			${EndIf}
			${If} ${FileExists} "$EXEDIR\Data\enchant\$4.exc"
				CopyFiles /SILENT "$EXEDIR\Data\enchant\$4.exc" "$LOCALAPPDATA\enchant"
			${EndIf}
		${EndIf}
		
		FindNext $0 $1
	${Loop}
	FindClose $0
!macroend

${SegmentPostPrimary}
	;Our variable to store the last short language handled
	StrCpy $5 "??"

	;Loop through included dictionaries
	FindFirst $0 $1 "$EXEDIR\App\Rednotebook\share\enchant\myspell\*.dic"
	${DoWhile} $1 != ""
		${GetBaseName} $1 $2
		
		;Copy our custom files if they exist
		${If} ${FileExists} "$LOCALAPPDATA\enchant\$2.dic"
			Delete "$EXEDIR\Data\enchant\$2.dic"
			CopyFiles /SILENT "$LOCALAPPDATA\enchant\$2.dic" "$EXEDIR\Data\enchant"
		${EndIf}
		${If} ${FileExists} "$LOCALAPPDATA\enchant\$2.exc"
			Delete "$EXEDIR\Data\enchant\$2.exc"
			CopyFiles /SILENT "$LOCALAPPDATA\enchant\$2.exc" "$EXEDIR\Data\enchant"
		${EndIf}
		
		;Restore existing custom dictionary files on the local machine
		Delete "$LOCALAPPDATA\enchant\$2.dic"
		Delete "$LOCALAPPDATA\enchant\$2.exc"
		Rename "$LOCALAPPDATA\enchant\$2.dic-backupByRedNotebookPortable" "$LOCALAPPDATA\enchant\$2.dic"
		Rename "$LOCALAPPDATA\enchant\$2.ext-backupByRedNotebookPortable" "$LOCALAPPDATA\enchant\$2.exc"
		
		;Determine if dealing with a compound locale like en_US and also handle en
		StrLen $3 $2
		StrCpy $4 $2 2
		${If} $3 > 2
		${AndIf} $4 != $5
			StrCpy $5 $4
			
			;Copy our custom files if they exist
			${If} ${FileExists} "$LOCALAPPDATA\enchant\$4.dic"
				Delete "$EXEDIR\Data\enchant\$4.dic"
				CopyFiles /SILENT "$LOCALAPPDATA\enchant\$4.dic" "$EXEDIR\Data\enchant"
				Delete "$LOCALAPPDATA\enchant\$4.dic"
			${EndIf}
			${If} ${FileExists} "$LOCALAPPDATA\enchant\$4.exc"
				Delete "$EXEDIR\Data\enchant\$4.exc"
				CopyFiles /SILENT "$LOCALAPPDATA\enchant\$4.exc" "$EXEDIR\Data\enchant"
				Delete "$LOCALAPPDATA\enchant\$4.exc"
			${EndIf}
			
			;Restore existing custom dictionary files on the local machine
			Rename "$LOCALAPPDATA\enchant\$4.dic-backupByRedNotebookPortable" "$LOCALAPPDATA\enchant\$4.dic"
			Rename "$LOCALAPPDATA\enchant\$4.ext-backupByRedNotebookPortable" "$LOCALAPPDATA\enchant\$4.exc"
		${EndIf}
		
		FindNext $0 $1
	${Loop}
	FindClose $0
!macroend