!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "0.63.1.5" $1
		${If} $1 == "2"  ;$0 is older than 0.63.1.5

		;cleaning up a crashed older install to prevent loss of settings
			${If} ${FileExists} "$INSTDIR\App\KiTTY\kitty.ini"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\kitty.ini"
				Rename "$INSTDIR\App\KiTTY\kitty.ini" "$INSTDIR\Data\kitty.ini"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\putty.log"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\putty.log"
				Rename "$INSTDIR\App\KiTTY\putty.log" "$INSTDIR\Data\putty.log"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Commands\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Commands\*.*"
				Rename "$INSTDIR\App\KiTTY\Commands\" "$INSTDIR\Data\Commands\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Folders\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Folders\*.*"
				Rename "$INSTDIR\App\KiTTY\Folders\" "$INSTDIR\Data\Folders\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Jumplist\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Jumplist\*.*"
				Rename "$INSTDIR\App\KiTTY\Jumplist\" "$INSTDIR\Data\Jumplist\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Launcher\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Launcher\*.*"
				Rename "$INSTDIR\App\KiTTY\Launcher\" "$INSTDIR\Data\Launcher\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Sessions\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Sessions\*.*"
				Rename "$INSTDIR\App\KiTTY\Sessions\" "$INSTDIR\Data\Sessions\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Sessions_Commands\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Sessions_Commands\*.*"
				Rename "$INSTDIR\App\KiTTY\Sessions_Commands\" "$INSTDIR\Data\Sessions_Commands\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\SshHostKeys\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\SshHostKeys\*.*"
				Rename "$INSTDIR\App\KiTTY\SshHostKeys\" "$INSTDIR\Data\SshHostKeys\"
			${EndIf}
			${If} ${FileExists} "$INSTDIR\App\KiTTY\Temp\*.*"
			${AndIfNot} ${FileExists} "$INSTDIR\Data\Temp\*.*"
				Rename "$INSTDIR\App\KiTTY\Temp\" "$INSTDIR\Data\Temp\"
			${EndIf}
		;setting data directory to Data folder	
			WriteINIStr "$INSTDIR\Data\kitty.ini" "KITTY" "configdir" "$INSTDIR\Data\" 
			DeleteINIStr "$INSTDIR\Data\kitty.ini" "KITTY" "#configdir"
		${EndIf}	
	${EndIf}
!macroend

!macro CustomCodePostInstall
WriteINIStr "$INSTDIR\App\DefaultData\kitty.ini" "KITTY" "configdir" "$INSTDIR\Data\" ;setting data directory to Data folder
DeleteINIStr "$INSTDIR\App\DefaultData\kitty.ini" "KITTY" "#configdir"
!macroend