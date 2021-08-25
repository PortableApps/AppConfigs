${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Notepad++64"
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Notepad++"
    ${EndIf}
!macroend

${SegmentPrePrimary}
	${If} ${FileExists} "$EXEDIR\Data\Config\plugins\config\*.*"
		Delete "$EXEDIR\Data\Config\plugins\config\nppPluginLis*.dll"
		${If} $Bits = 64
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\Config\plugins\Config\nppPluginList64.dll" "$EXEDIR\Data\Config\plugins\config"
			Rename "$EXEDIR\Data\Config\plugins\config\nppPluginList64.dll" "$EXEDIR\Data\Config\plugins\config\nppPluginList.dll"
		${Else}
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\Config\plugins\Config\nppPluginList32.dll" "$EXEDIR\Data\Config\plugins\config"
			Rename "$EXEDIR\Data\Config\plugins\config\nppPluginList32.dll" "$EXEDIR\Data\Config\plugins\config\nppPluginList.dll"
		${EndIf}
	${EndIf}
	CreateDirectory "$EXEDIR\App\Notepad++\cloud"
	CreateDirectory "$EXEDIR\App\Notepad++64\cloud"
	Delete "$EXEDIR\App\Notepad++\cloud\choice"
	;CopyFiles /SILENT "$EXEDIR\App\choice" "$EXEDIR\App\Notepad++\cloud"
	FileOpen $0 "$EXEDIR\App\Notepad++\cloud\choice" w
	FileWrite $0 "$EXEDIR\Data\Config"
	FileClose $0
	Delete "$EXEDIR\App\Notepad++64\cloud\choice"
	CopyFiles /SILENT "$EXEDIR\App\Notepad++\cloud\choice" "$EXEDIR\App\Notepad++64\cloud"
	
	${If} $Bits = 64
		${IfNot} ${FileExists} "$EXEDIR\App\Notepad++64\localization"
			Rename "$EXEDIR\App\Notepad++\localization" "$EXEDIR\App\Notepad++64\localization"
		${EndIf}
	${Else}
		${IfNot} ${FileExists} "$EXEDIR\App\Notepad++\localization"
			Rename "$EXEDIR\App\Notepad++64\localization" "$EXEDIR\App\Notepad++\localization"
		${EndIf}
	${EndIf}
!macroend
