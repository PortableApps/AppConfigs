${SegmentFile}
Var CustomFirstRunDone

${SegmentPrePrimary}
	${If} ${FileExists} "$SMPROGRAMS\Telegram.lnk"
		Rename "$SMPROGRAMS\Telegram.lnk" "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk"
	${EndIf}
	ReadINIStr $0 "$EXEDIR\Data\settings\TelegramPortableSettings.ini" "FirstRun" "Done"
	${If} $0 != true
		ClearErrors
		MessageBox MB_ICONINFORMATION|MB_OK "IMPORTANT ACCOUNT PORTABILITY NOTE!$\r$\n$\r$\nBy default, Telegram will store your local account media on the local machine and leave it behind on exit.  To ensure it is not left behind, after you create/login to your account, click Menu, Settings, Advanced, click Default Folder and select 'Temp Folder, cleared on logout...' and then click Save. This will ensure your synced data is not left behind as you move PCs."		
		StrCpy $CustomFirstRunDone true
	${EndIf}
!macroend
${SegmentPostPrimary}
	Delete "$SMPROGRAMS\Telegram.lnk"
	${If} ${FileExists} "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk"
		Rename "$SMPROGRAMS\Telegram-BackupByTelegramPortable.lnk" "$SMPROGRAMS\Telegram.lnk"
	${EndIf}
	${If} $CustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\TelegramPortableSettings.ini" "FirstRun" "Done" "true"
	${EndIf}
!macroend
