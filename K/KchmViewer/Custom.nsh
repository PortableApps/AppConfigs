${SegmentFile}

!macro _PreExecPrimary_RegMultiSzReplaceDriveLetter

# Code courtesy of Bart.S, OpenPlatform, and 3D1T0R
${Registry::Read} "$RegKey" "$RegValue" $R0 $R1
StrLen $1 $R0
${If} $R1 == "REG_MULTI_SZ"
${AndIf} $1 > 3 ; Test for empty value
	; Unfortunately the Registry::Read function puts a NewLine ($\n) between every character, this hack removes those while preserving NewLine ($\n) Characters which were supposed to be present
	; If we could fix Registry::Read we could remove the next 3 lines
	${WordReplace} $R0 "$\n$\n$\n" "/NEWLINE\" "+" $R2
	${WordReplace} $R2 "$\n" "" "+" $R2
	${WordReplace} $R2 "/NEWLINE\" "$\n" "+" $R2
#	${DebugMsg} "Reading from Registry:$\nRegistry Key:$\n$RegKey$\nRegistry Value:$\n$RegValue$\nContents:$\n$R2$\nAnd is Type:$\n$R1"
	${WordReplace} $R2 "$CustomLastDrive" "$CustomDrive" "+" $R3
#	${DebugMsg} "Replacing the LastDrive letter with the current Drive letter:$\nString begins as:$R2$\nString to find:$\n$LastDrive$\nString to replace with:$\n$Drive$\nResultant String:$\n$R3"
	${registry::Write} "$RegKey" "$RegValue" $R3 $R1 $R4
#	${DebugMsg} "Writing to Registry:$\nRegistry Key:$RegKey$\nRegistry Value:$\n$RegValue$\nContents:$\n$R5$\nAnd is Type:$\n$R1$\n$\n$R3$\nDid it work (0=Yes -1=Error):$\n$R4"
${Else}
#	${DebugMsg} "$RegValue in $RegKey is empty."
${EndIf}
!macroend

Var CustomLastDrive
Var CustomDrive
Var RegKey
Var RegValue

${SegmentPreExecPrimary}

	ReadEnvStr $CustomLastDrive "PAL:LastDrive"
	ReadEnvStr $CustomDrive "PAL:Drive"

	StrCpy $RegKey "HKEY_CURRENT_USER\Software\Ulduzsoft\kchmviewer"
	StrCpy $RegValue "recentFileList"
	!insertmacro _PreExecPrimary_RegMultiSzReplaceDriveLetter
!macroend