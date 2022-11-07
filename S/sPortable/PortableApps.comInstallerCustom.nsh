!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "8.0.0.0" $R0
		${If} $R0 == "2"
			${GetParent} $INSTDIR $0
			${IfNot} ${FileExists} "$0\sPortableLegacy7\App\AppInfo\appinfo.ini"
				CreateDirectory "$0\sPortableLegacy7"
				Rename "$INSTDIR\App" "$0\sPortableLegacy7\App"
				Rename "$INSTDIR\Data" "$0\sPortableLegacy7\Data"
				Rename "$INSTDIR\Other" "$0\sPortableLegacy7\Other"
				Rename "$INSTDIR\sPortable.exe" "$0\sPortableLegacy7\sPortable.exe"
				Rename "$INSTDIR\sPortable.ini" "$0\sPortableLegacy7\sPortable.ini"
				Rename "$INSTDIR\help.html" "$0\sPortableLegacy7\help.html"
				WriteINIStr "$0\sPortableLegacy7\App\AppInfo\appinfo.ini" "Details" "Name" "sPortable Legacy 7"
				WriteINIStr "$0\sPortableLegacy7\App\AppInfo\appinfo.ini" "Details" "AppID" "sPortableLegacy7"
			${Else}
				CreateDirectory "$INSTDIR\OldSkype"
				Rename "$INSTDIR\App" "$INSTDIR\OldSkype\App"
				Rename "$INSTDIR\Data" "$INSTDIR\OldSkype\Data"
				Rename "$INSTDIR\Other" "$INSTDIR\OldSkype\Other"
				Rename "$INSTDIR\sPortable.exe" "$INSTDIR\OldSkype\sPortable.exe"
				Rename "$INSTDIR\sPortable.ini" "$INSTDIR\OldSkype\sPortable.ini"
				Rename "$INSTDIR\help.html" "$INSTDIR\OldSkype\help.html"
				WriteINIStr "$INSTDIR\OldSkype\App\AppInfo\appinfo.ini" "Details" "Name" "sPortable Legacy 7"
				WriteINIStr "$INSTDIR\OldSkype\App\AppInfo\appinfo.ini" "Details" "AppID" "sPortableLegacy7"
			${EndIf}
		${Else}
			${VersionCompare} $0 "8.72.0.93" $R0
			${If} $R0 == "2"
				${GetParent} $INSTDIR $0
				${IfNot} ${FileExists} "$0\sPortableLegacy8\App\AppInfo\appinfo.ini"
					CreateDirectory "$0\sPortableLegacy8"
					Rename "$INSTDIR\App" "$0\sPortableLegacy8\App"
					Rename "$INSTDIR\Data" "$0\sPortableLegacy8\Data"
					Rename "$INSTDIR\Other" "$0\sPortableLegacy8\Other"
					Rename "$INSTDIR\sPortable.exe" "$0\sPortableLegacy8\sPortable.exe"
					Rename "$INSTDIR\sPortable.ini" "$0\sPortableLegacy8\sPortable.ini"
					Rename "$INSTDIR\help.html" "$0\sPortableLegacy8\help.html"
					WriteINIStr "$0\sPortableLegacy8\App\AppInfo\appinfo.ini" "Details" "Name" "sPortable Legacy 8"
					WriteINIStr "$0\sPortableLegacy8\App\AppInfo\appinfo.ini" "Details" "AppID" "sPortableLegacy8"
				${Else}
					CreateDirectory "$INSTDIR\OldSkype"
					Rename "$INSTDIR\App" "$INSTDIR\OldSkype\App"
					Rename "$INSTDIR\Data" "$INSTDIR\OldSkype\Data"
					Rename "$INSTDIR\Other" "$INSTDIR\OldSkype\Other"
					Rename "$INSTDIR\sPortable.exe" "$INSTDIR\OldSkype\sPortable.exe"
					Rename "$INSTDIR\sPortable.ini" "$INSTDIR\OldSkype\sPortable.ini"
					Rename "$INSTDIR\help.html" "$INSTDIR\OldSkype\help.html"
					WriteINIStr "$INSTDIR\OldSkype\App\AppInfo\appinfo.ini" "Details" "Name" "sPortable Legacy 8"
					WriteINIStr "$INSTDIR\OldSkype\App\AppInfo\appinfo.ini" "Details" "AppID" "sPortableLegacy8"
				${EndIf}
			${EndIf}
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	ReadINIStr $0 "$INSTDIR\App\AppInfo\installer.ini" "DownloadFiles" "DownloadFilename"
	nsExec::Exec `"$INSTDIR\App\bin\innounp.exe" -x -d"$INSTDIR\App\SkypeExtract" "$INSTDIR\App\SkypeInstaller\$0"`
	;nsExec::Exec `"$INSTDIR\App\bin\innoextract.exe" -s -d "$INSTDIR\App\SkypeExtract" "$INSTDIR\App\SkypeInstaller\$0"`
	Pop $R1
	RMDir /r "$INSTDIR\App\Skype"
	Rename "$INSTDIR\App\SkypeExtract\{App}" "$INSTDIR\App\Skype"
	RMDir /r "$INSTDIR\App\SkypeExtract"
	RMDir /r "$INSTDIR\App\SkypeInstaller"
	RMDir /r "$INSTDIR\App\bin"
	${If} ${FileExists} "$INSTDIR\Data\SkypeData\*.*"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\SkypeData\Skype-Setup.exe\*.*"
		CreateDirectory "$INSTDIR\Data\SkypeData\Skype-Setup.exe"
	${EndIf}
!macroend
