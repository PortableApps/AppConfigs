${SegmentFile}

${SegmentPostPrimary}
	StrCpy $2 "http://wisecleaner.com/promotions/topage.php?page=wpu"
	System::Call "wininet::DeleteUrlCacheEntryW(t '$2')i .r2"
	StrCpy $2 "http://wisecleaner.com/promotions/wyd/wyd.jpg"
	System::Call "wininet::DeleteUrlCacheEntryW(t '$2')i .r2"
!macroend