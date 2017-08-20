${SegmentFile}

Function GetDrives

		StrCpy $R0 $9 1
		Push $0

FunctionEnd

${SegmentInit}

	${GetDrives} "CDROM" "GetDrives"
    ${SetEnvironmentVariable} CDROM $R0

!macroend
