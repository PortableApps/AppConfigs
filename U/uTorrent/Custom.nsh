${SegmentFile}

; Implemented by Mark Sikkema at http://portableapps.com/node/23966
Function _Custom_DeleteFileGuard_
	Pop $0
	; $0 = filename
	; $R0 = handle
	; $R1 = file size
	; $R2 = file contents

	FileOpen $R0 $0 r
	FileRead $R0 $R1
	StrCpy $R1 $R1 17
	${If} $R1 == d10:.fileguard40:
		FileSeek $R0 0 END $R1 ; get file size
		FileSeek $R0 0 SET
		System::Alloc /NOUNLOAD $R1
		Pop $R2
		System::Call /NOUNLOAD 'Kernel32::ReadFile(i r10, i r12, i r11, t.,)'
		FileClose $R0
		IntOp $R2 $R2 + 57 ; delete fileguard
		IntOp $R1 $R1 - 57 ; shorten file size
		FileOpen $R0 $0 w
		FileWriteByte $R0 0x64 ; write the 'd'
		System::Call /NOUNLOAD 'Kernel32::WriteFile(i r10, i r12, i r11, t.,)'
		System::Free $R2
	${EndIf}
	FileClose $R0
FunctionEnd
!macro _Custom_DeleteFileGuard_ file
	Push "${file}"
	Call _Custom_DeleteFileGuard_
!macroend

;Implemented by John T. Haller
Function _Custom_UpdatePathVars_
	Pop $0
	
	ExpandEnvStrings $R0 "%PAL:LastDrive%%PAL:LastPackagePartialDir%\"
	ExpandEnvStrings $R1 "%PAL:Drive%%PAL:PackagePartialDir%\"
	
	${If} $R0 != $1
		StrLen $R2 $R0 ;Length of old path
		StrLen $R3 $R1 ;Length of new path
		
		;New path is longer
		${If} $R3 > $R2
			IntOp $R8 $R3 - $R2 ;$R8 contains the path size change
			
			${ForEach} $R9 300 20 - 1
				IntOp $R7 $R9 + $R8 ;$R7 contains what the path size would change to if it were $R9
				${ReplaceInFile} $0 ":Path$R9:$R0" ":Path$R7:$R1"
				;${ReplaceInFile} $0 ":dir_active_download$R9:$R0" ":dir_active_download$R7:$R1"
				${ReplaceInFile} $0 ":dir_torrent_files$R9:$R0" ":dir_torrent_files$R7:$R1"
				${ReplaceInFile} $0 "d$R9:$R0" "d$R7:$R1"
			${Next}
		${EndIf}
		
		;Old path is longer
		${If} $R2 > $R3
			IntOp $R8 $R2 - $R3 ;$R8 contains the path size change
			
			${For} $R9 20 300
				IntOp $R7 $R9 - $R8 ;$R7 contains what the path size would change to if it were $R9
				${If} $R7 > 0
					${ReplaceInFile} $0 ":Path$R9:$R0" ":Path$R7:$R1"
					;${ReplaceInFile} $0 ":dir_active_download$R9:$R0" ":dir_active_download$R7:$R1"
					${ReplaceInFile} $0 ":dir_torrent_files$R9:$R0" ":dir_torrent_files$R7:$R1"
					${ReplaceInFile} $0 "d$R9:$R0" "d$R7:$R1"
				${EndIf}
			${Next}
		${EndIf}
		
		;Paths the same length
		${If} $R2 == $R3
			${ReplaceInFile} $0 ":$R0" ":$R1"
		${EndIf}
	${EndIf}
FunctionEnd
!macro _Custom_UpdatePathVars_ file
	Push "${file}"
	Call _Custom_UpdatePathVars_
!macroend

${SegmentPrePrimary}
	!insertmacro _Custom_DeleteFileGuard_ $DataDirectory\settings\settings.dat
	!insertmacro _Custom_DeleteFileGuard_ $DataDirectory\settings\resume.dat
	
	!insertmacro _Custom_UpdatePathVars_ $DataDirectory\settings\settings.dat
	!insertmacro _Custom_UpdatePathVars_ $DataDirectory\settings\resume.dat
	
	ExpandEnvStrings $R0 "%PAL:LastDrive%%PAL:LastPackagePartialDir%\"
	ExpandEnvStrings $R1 "%PAL:Drive%%PAL:PackagePartialDir%\"
	${ReplaceInFile} "$DataDirectory\settings\resume.dat" ":$R0" ":$R1"
	
	ReadINIStr $1 "$EXEDIR\Data\settings\uTorrentPortableSettings.ini" "uTorrentPortableSettings" "ChangePath3.3Warning"
	${If} $1 != "true"
		MessageBox MB_OK|MB_ICONEXCLAMATION `MANUAL CHANGE REQUIRED: uTorrent removed support for relative paths in 3.3.  Prior versions of uTorrent Portable made use of relative paths.  When uTorrent starts, you will need to update your paths within Options - Preferences - Directories.  Set Downloaded files to '$EXEDIR\Data\downloads' and Store torrents in to '$EXEDIR\Data\torrents'. If you have any torrents in progress, you may be able to resume them by right-clicking, selecting Advanced and then selecting the downloads directory.`
		WriteINIStr "$EXEDIR\Data\settings\uTorrentPortableSettings.ini" "uTorrentPortableSettings" "ChangePath3.3Warning" "true"
	${EndIf}
	
	StrLen $1 "$EXEDIR\Data\downloads"
	StrLen $2 "$EXEDIR\Data\torrents"
	
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:CustomDownloadsPathLength", "$1").r0'
	System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:CustomTorrentsPathLength", "$2").r0'
!macroend
