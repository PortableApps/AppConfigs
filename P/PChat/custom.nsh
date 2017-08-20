${SegmentFile}

Var DefaultDccDirectory

${SegmentInit}
IfFileExists $PortableAppsDirectory\PortableApps.com\PortableAppsPlatform.exe" "" NoPlatform
	${SetEnvironmentVariable} DefaultDccDirectory "$PortableApps.comDocuments"
	Goto TheEnd
	NoPlatform:
	CreateDirectory $EXEDIR\Data\Downloads
	${SetEnvironmentVariable} DefaultDccDirectory "$EXEDIR\Data\Downloads"
	TheEnd:
!macroend