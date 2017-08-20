Var UpgradeBleachBitINIversion

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "0.9.2.0" $1
		${If} $1 == "2"  ;$0 is older than
		${AndIf} ${FileExists} "$INSTDIR\Data"
			StrCpy $UpgradeBleachBitINIversion true
			
			CreateDirectory "$INSTDIR\Data\cleaners"
			CopyFiles /SILENT "$INSTDIR\App\BleachBit\cleaners\*.*" "$INSTDIR\Data\cleaners"
			
			# Remove [PortableApps.comLauncher] line from BleachBitPortableSettings.ini - leftover from original portablization
			# Thanks to KiCHiK: http://nsis.sourceforge.net/Replacing_Lines_in_a_Text_File
			ClearErrors
			FileOpen $0 "$INSTDIR\Data\settings\BleachBitPortableSettings.ini" "r"                     ; open target file for reading
			GetTempFileName $R0                            ; get new temp file name
			FileOpen $1 $R0 "w"                            ; open temp file for writing
			loop:
				FileRead $0 $2                              ; read line from target file
				IfErrors done                               ; check if end of file reached
				StrCmp $2 "[PortableApps.comLauncher]$\r$\n" loop 0    ; if search string (with CR/LF) is found, goto loop
				StrCmp $2 "[PortableApps.comLauncher]" loop 0          ; if search string is found at the end of the file, goto loop
				 FileWrite $1 $2                             ; write changed or unchanged line to temp file
				Goto loop
 
			done:
				FileClose $0                                ; close target file
				FileClose $1                                ; close temp file
				Delete "$INSTDIR\Data\settings\BleachBitPortableSettings.ini"                           ; delete target file
				CopyFiles /SILENT $R0 "$INSTDIR\Data\settings\BleachBitPortableSettings.ini"            ; copy temp file to target file
				Delete $R0                                  ; delete temp file
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} $UpgradeBleachBitINIversion == true
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "DisplayVersion"
		WriteINIStr "$INSTDIR\Data\BleachBit.ini" "bleachbit" "version" "$0"
	${EndIf}
!macroend