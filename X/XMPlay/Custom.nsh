${SegmentFile}

Var FirstRun

${SegmentInit}

	${IfNot} ${FileExists} $EXEDIR\Data\settings
		StrCpy $FirstRun 1
	${EndIf}

!macroend

${SegmentPrePrimary}

	${If} $FirstRun = 1
		${If} ${FileExists} $CurrentDrive\Documents\Music
			StrCpy $0 "$CurrentDrive\Documents\Music\"
		${Else}
			StrCpy $0 "$CurrentDrive\"
		${EndIf}
		WriteINIStr $DataDirectory\xmplay\xmplay.ini XMPlay FilePath $0
	${EndIf}

	${registry::StrToHex} '$LastDirectory' $0
    ${SetEnvironmentVariable} PAL:LastPackagePartialDir:Hex $0
	${registry::StrToHex} '$CurrentDirectory' $0
    ${SetEnvironmentVariable} PAL:PackagePartialDir:Hex $0

	${registry::StrToHex} '$LastPortableAppsBaseDirectory' $0
    ${SetEnvironmentVariable} PAL:LastPortableAppsBaseDir:Hex $0
	${registry::StrToHex} '$PortableAppsBaseDirectory' $0
    ${SetEnvironmentVariable} PAL:PortableAppsBaseDir:Hex $0

	${registry::StrToHex} '$LastDrive' $0
    ${SetEnvironmentVariable} PAL:LastDrive:Hex $0
	${registry::StrToHex} '$CurrentDrive' $0
    ${SetEnvironmentVariable} PAL:Drive:Hex $0

!macroend
