${SegmentFile}

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\OperaPortable.ini" "PortableApps.comLauncher" "LastLanguageCustom"
	StrCpy $1 "%PAL:LanguageCustom%"
	${ParseLocations} $1

	${If} $0 != $1
		StrCpy $2 "$1,en-US;q=0.9,en;q=0.8"
		WriteINIStr "$EXEDIR\Data\profile\operaprefs.ini" "Network" "HTTP Accept Language" $2
		WriteINIStr "$EXEDIR\Data\settings\OperaPortable.ini" "PortableApps.comLauncher" "LastLanguageCustom" $1
	${EndIf}
!macroend