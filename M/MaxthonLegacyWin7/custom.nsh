${SegmentFile}

${Segment.OnInit}
	StrCpy $2 "7.2.2.7800" ;Maxthon Version

	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	StrCpy $1 0 ;Track changes
	${If} $0 == 0 ;32-bit
		${If} ${FileExists} "$EXEDIR\App\Maxthon32\*.*"
			Rename "$EXEDIR\App\Maxthon" "$EXEDIR\App\Maxthon64"
			Rename "$EXEDIR\App\Maxthon32" "$EXEDIR\App\Maxthon"
			StrCpy $1 "64"
			Sleep 500
		${EndIf}
	${Else} ;64-bit
		${If} ${FileExists} "$EXEDIR\App\Maxthon64\*.*"
			Rename "$EXEDIR\App\Maxthon" "$EXEDIR\App\Maxthon32"
			Rename "$EXEDIR\App\Maxthon64" "$EXEDIR\App\Maxthon"
			StrCpy $1 "32"
			Sleep 500
		${EndIf}
	${EndIf}
	${If} $1 != 0
		Rename "$EXEDIR\App\Maxthon$1\$2\data_files" "$EXEDIR\App\Maxthon\$2\data_files"
		Rename "$EXEDIR\App\Maxthon$1\$2\default_apps" "$EXEDIR\App\Maxthon\$2\default_apps"
		Rename "$EXEDIR\App\Maxthon$1\$2\default_notes" "$EXEDIR\App\Maxthon\$2\default_notes"
		Rename "$EXEDIR\App\Maxthon$1\$2\Extensions" "$EXEDIR\App\Maxthon\$2\Extensions"
		Rename "$EXEDIR\App\Maxthon$1\$2\Locales" "$EXEDIR\App\Maxthon\$2\Locales"
		Rename "$EXEDIR\App\Maxthon$1\$2\MEIPreload" "$EXEDIR\App\Maxthon\$2\MEIPreload"
		Rename "$EXEDIR\App\Maxthon$1\$2\skin" "$EXEDIR\App\Maxthon\$2\skin"
		Rename "$EXEDIR\App\Maxthon$1\$2\skin_pak" "$EXEDIR\App\Maxthon\$2\skin_pak"
		Rename "$EXEDIR\App\Maxthon$1\$2\VisualElements" "$EXEDIR\App\Maxthon\$2\VisualElements"
		Rename "$EXEDIR\App\Maxthon$1\$2\webui" "$EXEDIR\App\Maxthon\$2\webui"
		Rename "$EXEDIR\App\Maxthon$1\$2\chrome_100_percent.pak" "$EXEDIR\App\Maxthon\$2\chrome_100_percent.pak"
		Rename "$EXEDIR\App\Maxthon$1\$2\chrome_200_percent.pak" "$EXEDIR\App\Maxthon\$2\chrome_200_percent.pak"
		Rename "$EXEDIR\App\Maxthon$1\$2\icudtl.dat" "$EXEDIR\App\Maxthon\$2\icudtl.dat"
		Rename "$EXEDIR\App\Maxthon$1\$2\resources.pak" "$EXEDIR\App\Maxthon\$2\resources.pak"
		Sleep 500
	${EndIf}
!macroend