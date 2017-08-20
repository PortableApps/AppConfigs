${SegmentFile}

${SegmentPrePrimary}
	;Build Plugin Path
	${GetParent} $EXEDIR $0 ;PortableApps path
	
	StrCpy $1 "$EXEDIR\App\Opera\program\plugins\"
	${If} ${FileExists} "$JavaDirectory\Bin\plugin2\*.*"
		StrCpy $1 "$1;$JavaDirectory\Bin\plugin2\"
	${ElseIf} ${FileExists} "$JavaDirectory\Bin\New_Plugin\*.*"
		StrCpy $1 "$1;$JavaDirectory\Bin\New_Plugin\"
	${EndIf}
	${If} ${FileExists} "$0\CommonFiles\Silverlight\files\*.*"
		StrCpy $1 "$1;$0\CommonFiles\Silverlight\files\"
	${EndIf}
	${If} ${FileExists} "$0\CommonFiles\Flash\files\*.*"
		StrCpy $1 "$1;$0\CommonFiles\Flash\files\"
	${EndIf}
	${If} ${FileExists} "$0\CommonFiles\BrowserPlugins\*.*"
		StrCpy $1 "$1;$0\CommonFiles\BrowserPlugins\"
	${EndIf}
	${If} ${FileExists} "$EXEDIR\Data\profile\operaprefs.ini"
		WriteINIStr "$EXEDIR\Data\profile\operaprefs.ini" "User Prefs" "Plugin Path" $1
	${EndIf}
	
	Delete "$EXEDIR\App\Opera\operaprefs_default.ini"
	CopyFiles /SILENT "$EXEDIR\App\Opera\operaprefs_default_portable.ini" "$EXEDIR\App"
	Rename "$EXEDIR\App\operaprefs_default_portable.ini" "$EXEDIR\App\Opera\operaprefs_default.ini"
!macroend

${SegmentPreExecPrimary}
	Delete "$EXEDIR\App\Opera\profile\operaprefs.ini"
	CopyFiles /SILENT "$EXEDIR\Data\profile\operaprefs.ini" "$EXEDIR\App\Opera\profile\"
!macroend

${SegmentPostPrimary}
	Delete "$EXEDIR\Data\profile\operaprefs.ini"
	Rename "$EXEDIR\App\Opera\profile\operaprefs.ini" "$EXEDIR\Data\profile\operaprefs.ini"
!macroend