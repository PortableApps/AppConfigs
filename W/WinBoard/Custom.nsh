${SegmentFile}

!include WinMessages.nsh

${SegmentPrePrimary}
	;Load app ttf fonts
	FindFirst $0 $1 "$EXEDIR\App\fonts\*.ttf"
	${DoWhile} $1 != ""
		System::Call "gdi32::AddFontResource(t'$EXEDIR\App\fonts\$1')i .r2"
		FindNext $0 $1
	${Loop}
	FindClose $0
	
	;Let all running apps know
	SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=1
!macroend

${SegmentPostPrimary}
	;Remove app ttf fonts
	FindFirst $0 $1 "$EXEDIR\App\fonts\*.ttf"
	${DoWhile} $1 != ""
		System::Call "gdi32::RemoveFontResource(t'$EXEDIR\App\fonts\$1')i .r2"
		FindNext $0 $1
	${Loop}
	FindClose $0
	
	;Let all running apps know
	SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=1
!macroend
