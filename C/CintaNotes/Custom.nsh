${SegmentFile}

${SegmentPrePrimary}
	;Check for BOM
	${If} ${FileExists} "$EXEDIR\Data\cintanotes.settings"
		ClearErrors
		FileOpen $0 "$EXEDIR\Data\cintanotes.settings" r
		${IfNot} ${Errors}
			FileReadByte $0 $1
			FileReadByte $0 $2
			FileClose $0
			
			${IfNot} $1 == "255"
			${AndIfNot} $2 == "254"
				ClearErrors
				Delete "$EXEDIR\Data\cintanotes.settings.newfile"
				FileOpen $0 "$EXEDIR\Data\cintanotes.settings" r
				FileOpen $1 "$EXEDIR\Data\cintanotes.settings.newfile" w
				FileWriteByte $1 "255"
				FileWriteByte $1 "254"
				
				CustomCodeFileReadLoop:
					ClearErrors
					FileReadByte $0 $2
					IfErrors CustomCodeFileReadLoopExit
					FileWriteByte $1 $2
					Goto CustomCodeFileReadLoop

				CustomCodeFileReadLoopExit:
				FileClose $0
				FileClose $1
			
				Delete "$EXEDIR\Data\cintanotes.settings"
				Rename "$EXEDIR\Data\cintanotes.settings.newfile" "$EXEDIR\Data\cintanotes.settings"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend
