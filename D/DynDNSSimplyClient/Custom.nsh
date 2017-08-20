${SegmentFile}

${SegmentPreExecPrimary}
	;Backup the initial state of the files
	Delete "$EXEDIR\Data\settings-backup\DynDNSSimplyVirtual.reg"
	Delete "$EXEDIR\Data\settings-backup\DynDNSSimply.reg"
	CreateDirectory "$EXEDIR\Data\settings-backup"
	CopyFiles /SILENT "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg" "$EXEDIR\Data\settings-backup"
	CopyFiles /SILENT "$EXEDIR\Data\settings\DynDNSSimply.reg" "$EXEDIR\Data\settings-backup"
!macroend

${SegmentPostPrimary}
	${If} ${FileExists} "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg"
	${AndIf} ${FileExists} "$EXEDIR\Data\settings\DynDNSSimply.reg"
		;Both files exist, so we need to determine which one changed
		${If} ${FileExists} "$EXEDIR\Data\settings-backup\DynDNSSimplyVirtual.reg"
		${AndIf} ${FileExists} "$EXEDIR\Data\settings-backup\DynDNSSimply.reg"
			;We have backups of both files, determine which changed
			StrCpy $R0 ""
			${TextCompare} "$EXEDIR\Data\settings-backup\DynDNSSimplyVirtual.reg" "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg" "FastDiff" "TextCompareExitCall"
			ClearErrors
			${If} $R0 == "NotEqual"
				;Virtual changed, copy to standard
				Delete "$EXEDIR\Data\settings\DynDNSSimply.reg"
				CopyFiles /SILENT "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg" "$EXEDIR\Data"
				Rename "$EXEDIR\Data\DynDNSSimplyVirtual.reg" "$EXEDIR\Data\settings\DynDNSSimply.reg"
			${Else}
				StrCpy $R0 ""
				${TextCompare} "$EXEDIR\Data\settings-backup\DynDNSSimply.reg" "$EXEDIR\Data\settings\DynDNSSimply.reg" "FastDiff" "TextCompareExitCall"
				ClearErrors
				${If} $R0 == "NotEqual"
					;Standard changed, copy to virtual
					Delete "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg"
					CopyFiles /SILENT "$EXEDIR\Data\settings\DynDNSSimply.reg" "$EXEDIR\Data"
					Rename "$EXEDIR\Data\DynDNSSimply.reg" "$EXEDIR\Data\settings\DynDNSSimplyVirtual.reg"
				${Else}
					;Nothing changed, no copies need to be made
				${EndIf}
			${EndIf}
		${Else}
			;We only have a backup of one file, something went wrong
		${EndIf}
	${EndIf}
!macroend

Function TextCompareExitCall
	StrCpy $R0 NotEqual
	StrCpy $0 StopTextCompare

	Push $0
FunctionEnd