${SegmentFile}

${SegmentPrePrimary}
	ExpandEnvStrings $0 "%PAL:DataDir%"
	ExpandEnvStrings $1 "%PAL:AppDir%"
	ExpandEnvStrings $2 "%PAL:LastDrive%%PAL:LastPackagePartialDir%"
	ExpandEnvStrings $3 "%PAL:Drive%%PAL:PackagePartialDir%"
	${If} ${FileExists} "$0\settings\mmexini.db3"
		nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\settings\mmexini.db3" "UPDATE SETTING_V1 SET SETTINGVALUE = '$3' || SUBSTR(SETTINGVALUE,(LENGTH('$2')+1)) WHERE SETTINGVALUE LIKE '$2%';"`
	${EndIf}
!macroend