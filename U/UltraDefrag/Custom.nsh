${SegmentFile}

Var bolCleanupFragLists

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\UltraDefrag\x64
    ${Else}
        ${SetEnvironmentVariablesPath} FullAppDir $EXEDIR\App\UltraDefrag\x86
    ${EndIf}
!macroend

${SegmentPrePrimary}
	StrCpy $bolCleanupFragLists false
	${GetDrives} "HDD" GetDrivesCallBackCustom
!macroend

${SegmentPostPrimary}
	StrCpy $bolCleanupFragLists true
	${GetDrives} "HDD" GetDrivesCallBackCustom
!macroend

Function GetDrivesCallBackCustom
	${If} $bolCleanupFragLists == true
		Delete "$9\fraglist.luar"	
		Rename "$9\fraglist-BackupByUltraDefragPortable.luar" "$9\fraglist.luar"
	${Else}
		Delete "$9\fraglist-BackupByUltraDefragPortable.luar"
		Rename "$9\fraglist.luar" "$9\fraglist-BackupByUltraDefragPortable.luar"
	${EndIf}
	 Push $0
FunctionEnd
