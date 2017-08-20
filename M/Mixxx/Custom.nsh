${SegmentFile}

Var LastMixxxMusic

${SegmentInit}
	${SetEnvironmentVariablesPath} MUSIC $MUSIC
	${If} ${FileExists} "$EXEDIR\Data\settings\MixxxPortableSettings.ini"
		READINIStr $4 "$EXEDIR\Data\settings\MixxxPortableSettings.ini" MixxxPortableSettings LastMixxxMusic
		${SetEnvironmentVariablesPath} LastMixxxMusic $4
	${EndIf}
!macroend

${SegmentPrePrimary}

	ExpandEnvStrings $2 "%PAL:LastDrive%%PAL:LastPackagePartialDir%\"
	ExpandEnvStrings $3 "%PAL:Drive%%PAL:PackagePartialDir%\"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE directories SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir%\"
	ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir%\"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE directories SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastDrive%\"
	ExpandEnvStrings $3 "%PAL:Drive%\"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE directories SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
	${EndIf}

	ExpandEnvStrings $2 "%PAL:LastDrive%%PAL:LastPackagePartialDir:ForwardSlash%/"
	ExpandEnvStrings $3 "%PAL:Drive%%PAL:PackagePartialDir:ForwardSlash%/"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE LibraryHashes SET directory_path = '$3' || SUBSTR(directory_path,(LENGTH('$2')+1)) WHERE directory_path LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET location = '$3' || SUBSTR(location,(LENGTH('$2')+1)) WHERE location LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir:ForwardSlash%/"
	ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir:ForwardSlash%/"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE LibraryHashes SET directory_path = '$3' || SUBSTR(directory_path,(LENGTH('$2')+1)) WHERE directory_path LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET location = '$3' || SUBSTR(location,(LENGTH('$2')+1)) WHERE location LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastDrive%/"
	ExpandEnvStrings $3 "%PAL:Drive%/"
	${If} ${FileExists} "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE LibraryHashes SET directory_path = '$3' || SUBSTR(directory_path,(LENGTH('$2')+1)) WHERE directory_path LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET directory = '$3' || SUBSTR(directory,(LENGTH('$2')+1)) WHERE directory LIKE '$2%';"`
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\MixxxSettings\mixxxdb.sqlite" "UPDATE track_locations SET location = '$3' || SUBSTR(location,(LENGTH('$2')+1)) WHERE location LIKE '$2%';"`
	${EndIf}
!macroend