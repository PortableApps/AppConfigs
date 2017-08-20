${SegmentFile}

${SegmentPostPrimary}
	;Remove app ttf fonts
	FindFirst $0 $1 "$EXEDIR\App\ControlPad\Fonts\*.ttf"
	${DoWhile} $1 != ""
		System::Call "gdi32::RemoveFontResource(t'$EXEDIR\App\ControlPad\Fonts\$1')i .r2"
		FindNext $0 $1
	${Loop}
	FindClose $0
	
	;Let all running apps know
	SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=1
!macroend
