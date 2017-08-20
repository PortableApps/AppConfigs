${SegmentFile}

${SegmentPrePrimary}
	SetShellVarContext all
	IfFileExists "$DOCUMENTS\Rocks'n'Diamonds" 0 +3
	SetOutPath $DOCUMENTS
	Rename "$DOCUMENTS\Rocks'n'Diamonds" "$DOCUMENTS\Rocks'n'Diamonds-BackupByRocks'n'DiamondsPortable"
!macroend
${SegmentPostPrimary}
	SetShellVarContext all
	CopyFiles /SILENT "$DOCUMENTS\Rocks'n'Diamonds\*.*" "$EXEDIR\Data\Rocks'n'Diamonds"
	RMDir /r "$DOCUMENTS\Rocks'n'Diamonds"
	IfFileExists "$DOCUMENTS\Rocks'n'Diamonds-BackupByRocks'n'DiamondPortable" 0 +3
	SetOutPath $DOCUMENTS
	Rename "$DOCUMENTS\Rocks'n'Diamonds-BackupByRocks'n'DiamondsPortable" "$DOCUMENTS\Rocks'n'Diamonds"
!macroend