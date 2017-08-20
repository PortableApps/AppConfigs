${SegmentFile}

${SegmentPrePrimary}
	${If} ${FileExists} "$EXEDIR\Data\config\config.db"
		nsExec::Exec `"$EXEDIR\App\bin\sqlite3.exe" "$EXEDIR\Data\config\config.db" "UPDATE conf SET value = '$EXEDIR\Data\backup' WHERE name = 'folder_backup';"`
		nsExec::Exec `"$EXEDIR\App\bin\sqlite3.exe" "$EXEDIR\Data\config\config.db" "UPDATE conf SET value = '$EXEDIR\Data\temphandlemsg' WHERE name = 'temp_folder_handlemsg';"`
		nsExec::Exec `"$EXEDIR\App\bin\sqlite3.exe" "$EXEDIR\Data\config\config.db" "UPDATE conf SET value = '$EXEDIR\Data\tempsendimg' WHERE name = 'temp_folder_sendimg';"`
	${EndIf}
!macroend
