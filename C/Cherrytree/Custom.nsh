${SegmentFile}

${SegmentPre}
	ReadEnvStr $0 "PortableApps.comLocaleName"
	ReadEnvStr $1 "PortableApps.comLocaleName_INTERNAL"
	
	
	${If} $0 != ""
	${AndIf} $0 == $1		
		;Only do language switching with the platform
		ReadEnvStr $0 PAL:LanguageCustom
			  		
		ClearErrors
		FileOpen $1 "$EXEDIR\Data\cherrytree\lang" r
		IfErrors write
		FileRead $1 $2
		FileClose $1
		
		${If} $0 != $2
			write:
			FileOpen $3 "$EXEDIR\Data\cherrytree\lang" w
			IfErrors done
			FileWrite $3 $0
			FileClose $3
		${EndIf}
		
		done:
	${EndIf}
!macroend

${SegmentPost}
	;Clean up the malfunctioning dbus process
	${GetProcessPID} "dbus-daemon.exe" $0
	${GetProcessPath} $0 $1
	${If} $1 == "$EXEDIR\App\CherryTree\bin\dbus-daemon.exe"
		${TerminateProcess} $0 $2
	${EndIf}
!macroend