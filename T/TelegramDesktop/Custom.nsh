${SegmentFile}

${SegmentPrePrimary}
	${If} ${FileExists} "$SMPROGRAMS\Telegram.lnk"
		Rename "$SMPROGRAMS\Telegram.lnk" "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk"
	${EndIf}
!macroend
${SegmentPostPrimary}
	Delete "$SMPROGRAMS\Telegram.lnk"
	${If} ${FileExists} "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk"
		Rename "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk" "$SMPROGRAMS\Telegram.lnk"
	${EndIf}
!macroend
