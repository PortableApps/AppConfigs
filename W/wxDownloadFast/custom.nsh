${SegmentFile}

${SegmentInit}
	ExpandEnvStrings $1 "%PortableApps.comDownloads%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		${GetParent} $EXEDIR $3
		${GetParent} $3 $1
		${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $3
		${EndIf}
		${If} ${FileExists} "$1\Downloads\*.*"
			StrCpy $2 "$1\Downloads"
		${Else}
			${GetRoot} $EXEDIR $1
			${If} ${FileExists} "$1\Downloads\*.*"
				StrCpy $2 "$1\Downloads"
			${Else}
				StrCpy $2 "$1"
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDownloads", "$2").r0'
		${WordReplace} $2 "\" "\\" "+" $3
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDownloads:DoubleBackslash", "$3").r0'
	${EndIf}
	
	${GetParent} $EXEDIR $1
	${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $EXEDIR
		${EndIf}

	${If} ${FileExists} "$1\FirefoxPortable\FirefoxPortable.exe"
		StrCpy $2 "$1\FirefoxPortable\FirefoxPortable.exe"
	${ElseIf} ${FileExists} "$1\GoogleChromePortable\GoogleChromePortable.exe"
		StrCpy $2 "$1\GoogleChromePortable\GoogleChromePortable.exe"
	${ElseIf} ${FileExists} "$1\OperaPortable\OperaPortable.exe"
		StrCpy $2 "$1\OperaPortable\OperaPortable.exe"
	${ElseIf} ${FileExists} "$1\IronPortable\IronPortable.exe"
		StrCpy $2 "$1\IronPortable\IronPortable.exe"
	${Else}
		StrCpy $2 "$1\FirefoxPortable\FirefoxPortable.exe"
	${EndIf}
	${WordReplace} $2 "\" "\\" "+" $3
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDefaultBrowser:DoubleBackslash", "$3").r0'
!macroend