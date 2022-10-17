${SegmentFile}

${SegmentInit}
	ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $0 < 10000
		;Windows 7/8/8.1
		StrCpy $Bits 32
	${EndIf}
	
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\CaesiumModern"
			Rename "$EXEDIR\App\Caesium" "$EXEDIR\App\CaesiumLegacy"
			Rename "$EXEDIR\App\CaesiumModern" "$EXEDIR\App\Caesium"
		${EndIf}
	${Else}
        ${If} ${FileExists} "$EXEDIR\App\CaesiumLegacy"
			Rename "$EXEDIR\App\Caesium" "$EXEDIR\App\CaesiumModern"
			Rename "$EXEDIR\App\CaesiumLegacy" "$EXEDIR\App\Caesium"
		${EndIf}
	${EndIf}
	
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
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comPictures", "$2").r0'
		${WordReplace} $2 "\" "/" "+" $3
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comPictures:ForwardSlash", "$3").r0'
	${EndIf}
!macroend