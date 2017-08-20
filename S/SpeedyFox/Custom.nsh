${SegmentFile}

${SegmentInit}
	${IfNot} ${FileExists} "$EXEDIR\Data\preferences.xml"
		${GetParent} $EXEDIR $0
		StrCpy $1 ""

		;Firefox
		${If} ${FileExists} "$0\FirefoxPortable\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\FirefoxPortable\Data\profile</Profile>`
		${EndIf}
		
		;Firefox ESR
		${If} ${FileExists} "$0\FirefoxPortableESR\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\FirefoxPortableESR\Data\profile</Profile>`
		${EndIf}
		
		;Firefox Beta
		${If} ${FileExists} "$0\FirefoxPortableTest\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\FirefoxPortableTest\Data\profile</Profile>`
		${EndIf}
		
		;Firefox 2nd Profile
		${If} ${FileExists} "$0\FirefoxPortable2ndProfile\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\FirefoxPortable2ndProfile\Data\profile</Profile>`
		${EndIf}
		
		;Chrome
		${If} ${FileExists} "$0\GoogleChromePortable\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Chrome">$0\GoogleChromePortable\Data\profile</Profile>`
		${EndIf}
		
		;Chrome Beta
		${If} ${FileExists} "$0\GoogleChromePortableBeta\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Chrome">$0\GoogleChromePortableBeta\Data\profile</Profile>`
		${EndIf}
		
		;Chrome Dev
		${If} ${FileExists} "$0\GoogleChromePortableDev\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Chrome">$0\GoogleChromePortableDev\Data\profile</Profile>`
		${EndIf}

		;Iron
		${If} ${FileExists} "$0\IronPortable\Data\IronPortableData\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Chromium/Iron">$0\IronPortable\Data\IronPortableData</Profile>`
		${EndIf}	
		
		;SeaMonkey
		${If} ${FileExists} "$0\SeaMonkeyPortable\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\SeaMonkeyPortable\Data\profile</Profile>`
		${EndIf}
		
		;SeaMonkey 2nd Profile
		${If} ${FileExists} "$0\SeaMonkeyPortable2ndProfile\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Firefox">$0\SeaMonkeyPortable2ndProfile\Data\profile</Profile>`
		${EndIf}
		
		;Thunderbird
		${If} ${FileExists} "$0\ThunderbirdPortable\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Thunderbird">$0\ThunderbirdPortable\Data\profile</Profile>`
		${EndIf}
		
		;Thunderbird ESR
		${If} ${FileExists} "$0\ThunderbirdPortableESR\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Thunderbird">$0\ThunderbirdPortableESR\Data\profile</Profile>`
		${EndIf}
		
		;Thunderbird Beta
		${If} ${FileExists} "$0\ThunderbirdPortableTest\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Thunderbird">$0\ThunderbirdPortableTest\Data\profile</Profile>`
		${EndIf}
		
		;Thunderbird 2nd Profile
		${If} ${FileExists} "$0\ThunderbirdPortable2ndProfile\Data\profile\*.*"
			StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Thunderbird">$0\ThunderbirdPortable2ndProfile\Data\profile</Profile>`
		${EndIf}
		
		;Skype
		${If} ${FileExists} "$0\SkypePortable\Data\settings\*.*"
			${ForEachDirectory} $2 $3 "$0\SkypePortable\Data\settings\*"
				# $2 = full path, $3 = directory name
				${If} ${FileExists} "$0\SkypePortable\Data\settings\$3\config.xml"
					StrCpy $1 `$1$\r$\n$\t<Profile custom="yes" checked="yes" type="Skype">$0\SkypePortable\Data\settings\$3</Profile>`
				${EndIf}
			${NextDirectory}
		${EndIf}
		
		${SetEnvironmentVariablesPath} SpeedyFoxPortableDefaultSettings $1
	${EndIf}
!macroend
