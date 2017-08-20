${SegmentFile}

${SegmentInit}
	;Modified specially for Lightscreen, do not use in other apps!
	ExpandEnvStrings $1 "%PortableApps.comDocuments%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		${GetParent} $EXEDIR $3
		${GetParent} $3 $1
		${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $3
		${EndIf}
		${If} ${FileExists} "$1\Documents\*.*"
			StrCpy $2 "$1\Documents"
		${Else}
			${GetRoot} $EXEDIR $1
			${If} ${FileExists} "$1\Documents\*.*"
				StrCpy $2 "$1\Documents"
			${Else}
				StrCpy $2 "$1"
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDocuments", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comPictures%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Pictures\*.*"
			StrCpy $2 "$1\Pictures"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Pictures\*.*"
				StrCpy $2 "$1\Pictures"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Pictures\*.*"
					StrCpy $2 "$1\Pictures"
				${Else}
					StrCpy $2 "$EXEDIR\Data\Screenshots"
					CreateDirectory "$EXEDIR\Data\Screenshots"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comPictures", "$2").r0'
	${EndIf}
!macroend

${SegmentPrePrimary}
	ExpandEnvStrings $2 "%PAL:LastDrive%%PAL:LastPackagePartialDir%\"
	ExpandEnvStrings $3 "%PAL:Drive%%PAL:PackagePartialDir%\"
	${If} ${FileExists} "$EXEDIR\Data\settings\history.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\settings\history.sqlite" "UPDATE history SET fileName = '$3' || SUBSTR(fileName,(LENGTH('$2')+1)) WHERE fileName LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir%\"
	ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir%\"
	${If} ${FileExists} "$EXEDIR\Data\settings\history.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\settings\history.sqlite" "UPDATE history SET fileName = '$3' || SUBSTR(fileName,(LENGTH('$2')+1)) WHERE fileName LIKE '$2%';"`
	${EndIf}
	
	ExpandEnvStrings $2 "%PAL:LastDrive%\"
	ExpandEnvStrings $3 "%PAL:Drive%\"
	${If} ${FileExists} "$EXEDIR\Data\settings\history.sqlite"
	${AndIf} $2 != $3
		nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$EXEDIR\Data\settings\history.sqlite" "UPDATE history SET fileName = '$3' || SUBSTR(fileName,(LENGTH('$2')+1)) WHERE fileName LIKE '$2%';"`
	${EndIf}
!macroend