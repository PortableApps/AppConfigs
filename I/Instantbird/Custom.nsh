${SegmentFile}

${SegmentPrePrimary}
	ExpandEnvStrings $0 "%PAL:DataDir%"
	ExpandEnvStrings $1 "%PAL:AppDir%"
	ExpandEnvStrings $2 "%PAL:LastDrive%%PAL:LastPackagePartialDir%"
	ExpandEnvStrings $3 "%PAL:Drive%%PAL:PackagePartialDir%"
	${If} ${FileExists} "$0\profile\extensions.sqlite"
		nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\profile\extensions.sqlite" "UPDATE addon SET descriptor = '$3' || SUBSTR(descriptor,(LENGTH('$2')+1)) WHERE descriptor LIKE '$2%';"`
	${EndIf}
	${If} ${FileExists} "$0\profile\prefs.js"
		${WordReplace} $2 "\" "////" "+" $2
		${WordReplace} $2 "////" "\\\\" "+" $2
		${WordReplace} $3 "\" "////" "+" $3
		${WordReplace} $3 "////" "\\\\" "+" $3
		${ReplaceInFile} "$0\profile\prefs.js" $2 $3
	${EndIf}
!macroend