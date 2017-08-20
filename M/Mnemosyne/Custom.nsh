${SegmentFile}

${SegmentPrePrimary}
	${If} ${FileExists} "$EXEDIR\Data\Mnemosyne\config"
		ExpandEnvStrings $0 "%PAL:LastDrive%%PAL:LastPackagePartialDir%"
		ExpandEnvStrings $1 "%PAL:Drive%%PAL:PackagePartialDir%"
		${WordReplace} $0 "\" "\u005C" "+" $0
		${WordReplace} $1 "\" "\u005C" "+" $1
		${ReplaceInFile} "$EXEDIR\Data\Mnemosyne\config" $0 $1
	${EndIf}
!macroend