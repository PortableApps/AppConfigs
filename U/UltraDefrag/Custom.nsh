${SegmentFile}

Var bolCleanupFragLists

${Segment.OnInit}
	; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0
		StrCpy $Bits 32
	${Else}
		StrCpy $Bits 64
	${EndIf}
!macroend

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
