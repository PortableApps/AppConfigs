${SegmentFile} ;Note that Hot Spot Studio can only open JPGs, BMPs, and GIFs, so we'll only worry bout those exts.

${SegmentPrePrimary}

	${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" $R0
		StrCmp $R0 "0" "" +2
		${registry::SaveKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" "$APPDATA\HotSpotStudioPortableBackup.jpg.reg" "" $0
	
	${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" $R0
		StrCmp $R0 "0" "" +2
		${registry::SaveKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" "$APPDATA\HotSpotStudioPortableBackup.bmp.reg" "" $0

	${registry::KeyExists} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" $R0
		StrCmp $R0 "0" "" +2
		${registry::SaveKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" "$APPDATA\HotSpotStudioPortableBackup.gif.reg" "" $0
	
!macroend

${SegmentPostPrimary}

	${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" $R0
	IfFileExists "$APPDATA\HotSpotStudioPortableBackup.jpg.reg" "" +3
		${registry::RestoreKey} "$APPDATA\HotSpotStudioPortableBackup.jpg.reg" $R0
		Delete "$APPDATA\HotSpotStudioPortableBackup.jpg.reg"
	
	${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" $R0
	IfFileExists "$APPDATA\HotSpotStudioPortableBackup.bmp.reg" "" +3
		${registry::RestoreKey} "$APPDATA\HotSpotStudioPortableBackup.bmp.reg" $R0
		Delete "$APPDATA\HotSpotStudioPortableBackup.bmp.reg"
		
	${registry::DeleteKey} "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" $R0	
	IfFileExists "$APPDATA\HotSpotStudioPortableBackup.gif.reg" "" +3
		${registry::RestoreKey} "$APPDATA\HotSpotStudioPortableBackup.gif.reg" $R0
		Delete "$APPDATA\HotSpotStudioPortableBackup.gif.reg"
		
!macroend