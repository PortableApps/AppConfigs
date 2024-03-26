${SegmentFile}

${SegmentPreExecPrimary}
	;Code with help from Bart.S, OpenPlatform, and 3D1T0R
	${Registry::Read} "HKCU\Software\Ulduzsoft\kchmviewer" "recentFileList" $R0 $R1
	StrLen $R2 $R0
	${If} $R1 == "REG_MULTI_SZ"
	${AndIf} $R2 > 3 ;Ensure a populated REG_MULTI_SZ
		;Replace newling between characters while preserving actual new lines
		${WordReplace} $R0 "$\n$\n$\n" "/NEWLINE\" "+" $R2
		${WordReplace} $R2 "$\n" "" "+" $R2
		${WordReplace} $R2 "/NEWLINE\" "$\n" "+" $R2

		ExpandEnvStrings $4 "%PAL:LastDrive%"
		ExpandEnvStrings $5 "%PAL:Drive%"
		ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir:ForwardSlash%"
		ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir:ForwardSlash%"
		ExpandEnvStrings $6 "%PAL:LastDrive%%PAL:LastPackagePartialDir:ForwardSlash%"
		ExpandEnvStrings $7 "%PAL:Drive%%PAL:PackagePartialDir:ForwardSlash%"
	
		${WordReplace} $R2 "$6/" "$7/" "+" $R2
		${WordReplace} $R2 "$2/" "$3/" "+" $R2
		${WordReplace} $R2 "$4/" "$5/" "+" $R2
		
		${registry::Write} "HKCU\Software\Ulduzsoft\kchmviewer" "recentFileList" $R2 "REG_MULTI_SZ" $R9
	${EndIf}
!macroend