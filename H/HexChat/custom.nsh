${SegmentFile}

${SegmentInit}
	;Ensure we have a proper Downloads path for HexChat
	ExpandEnvStrings $1 "%PortableApps.comDocuments%"
	
	${If} ${FileExists} "$1\*.*"
		${SetEnvironmentVariable} DefaultDccDirectory "$1"
	${Else}
		${SetEnvironmentVariable} DefaultDccDirectory "$EXEDIR\Data\Downloads"
	${EndIf}
!macroend