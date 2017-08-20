${SegmentFile}
Var CustomFirstRunDone

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\PicPickPortableSettings.ini" "FirstRun" "Done"
	${If} $0 != true
		ClearErrors
		MessageBox MB_ICONINFORMATION|MB_OK "FOR PERSONAL(HOME) USE ONLY$\r$\n$\r$\nThis version is provided as freeware for only personal use. In this case, you are granted the right to use this program free of charge. Otherwise, you need to pay for a license for commercial use."
		StrCpy $CustomFirstRunDone true
	${EndIf}
!macroend

${SegmentPost}
	${If} $CustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\PicPickPortableSettings.ini" "FirstRun" "Done" "true"
	${EndIf}
!macroend