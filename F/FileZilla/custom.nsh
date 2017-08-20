${SegmentFile}

${SegmentPrePrimary}
	ExpandEnvStrings $0 "%PAL:DataDir%"
	ExpandEnvStrings $1 "%PAL:AppDir%"
	ExpandEnvStrings $4 "%PAL:LastDrive%"
	ExpandEnvStrings $5 "%PAL:Drive%"
	ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir%"
	ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir%"
	ExpandEnvStrings $6 "%PAL:LastDrive%%PAL:LastPackagePartialDir%"
	ExpandEnvStrings $7 "%PAL:Drive%%PAL:PackagePartialDir%"
	
	${If} ${FileExists} "$0\settings\queue.sqlite3"
		${If} $6 != $7
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\settings\queue.sqlite3" "UPDATE local_paths SET path = '$7' || SUBSTR(path,(LENGTH('$6')+1)) WHERE path LIKE '$6%';"`
		${EndIf}
		${If} $2 != $3
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\settings\queue.sqlite3" "UPDATE local_paths SET path = '$3' || SUBSTR(path,(LENGTH('$2')+1)) WHERE path LIKE '$2%';"`
		${EndIf}
		${If} $4 != $5
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\settings\queue.sqlite3" "UPDATE local_paths SET path = '$5' || SUBSTR(path,(LENGTH('$4')+1)) WHERE path LIKE '$4%';"`
		${EndIf}
	${EndIf}
!macroend
