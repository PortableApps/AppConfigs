${SegmentFile}

${SegmentInit}
    ${If} ${IsWin2000}
	${OrIf} ${IsWinXP}
	${OrIf} ${IsWin2003}
	${OrIf} ${IsWinVista}
	${OrIf} ${IsWin2008}
	${OrIf} ${IsWin7}
	${OrIf} ${IsWin2008R2}
		${If} ${FileExists} "$EXEDIR\App\TCPView-Legacy\*.*"
			Rename "$EXEDIR\App\TCPView" "$EXEDIR\App\TCPView-Modern"
			Rename "$EXEDIR\App\TCPView-Legacy" "$EXEDIR\App\TCPView"
			${IfNot} ${FileExists} "$EXEDIR\App\TCPView\TCPView64.exe"
				CopyFiles /SILENT "$EXEDIR\App\TCPView\TCPView.exe" "$EXEDIR\App"
				Rename "$EXEDIR\App\TCPView.exe" "$EXEDIR\App\TCPView\TCPView64.exe"
			${EndIf}
		${EndIf}
    ${Else}
	    ${If} ${FileExists} "$EXEDIR\App\TCPView-Modern\*.*"
			Rename "$EXEDIR\App\TCPView" "$EXEDIR\App\TCPView-Legacy"
			Rename "$EXEDIR\App\TCPView-Modern" "$EXEDIR\App\TCPView"
		${EndIf}
	${EndIf}
!macroend

${SegmentPre}
	ReadRegStr $0 HKLM "HARDWARE\DESCRIPTION\System" "Identifier"
	StrCpy $1 $0 3 0
		
	${If} $1 == "ARM"
		${ReadLauncherConfig} $ProgramExecutable Launch ProgramExecutableARM64
	${EndIf}
!macroend