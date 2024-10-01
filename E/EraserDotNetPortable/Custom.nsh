${SegmentFile}

${Segment.OnInit}
	${If} ${FileExists} "$EXEDIR\Data\settings\DotErsy.reg"
		Delete "$EXEDIR\Data\settings\DotErsy.reg"
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\DotErsy.reg" "$EXEDIR\Data\settings"
	${EndIf}
	${If} ${FileExists} "$EXEDIR\Data\settings\EraserDotErsy.reg"
		Delete "$EXEDIR\Data\settings\EraserDotErsy.reg"
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\EraserDotErsy.reg" "$EXEDIR\Data\settings"
	${EndIf}
	${If} ${FileExists} "$EXEDIR\Data\settings\EraserAppPaths.reg"
		Delete "$EXEDIR\Data\settings\EraserAppPaths.reg"
		CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\EraserAppPaths.reg" "$EXEDIR\Data\settings"
	${EndIf}
!macroend

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} PAcLauncherBits "64"
	${Else}
        ${SetEnvironmentVariablesPath} PAcLauncherBits ""
	${EndIf}
!macroend