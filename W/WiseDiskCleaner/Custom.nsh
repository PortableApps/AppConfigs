${SegmentFile}

${SegmentPostPrimary}
	${If} ${FileExists} "$EXEDIR\Data\WiseDiskCleanerAPPDATA\UpdateInfo\UpdateInfo.txt"
		${ConfigRead} "$EXEDIR\Data\WiseDiskCleanerAPPDATA\UpdateInfo\UpdateInfo.txt" "{" $0
		${WordFind} $0 '"imgsrc":"' "+02" $1
		${WordFind} $1 '"' "+01" $2
		${WordReplace} $2 "\/" "/" "+" $2
		System::Call "wininet::DeleteUrlCacheEntryW(t '$2')i .r2"		
	${EndIf}
!macroend