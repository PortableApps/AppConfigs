${SegmentFile}

${SegmentPrePrimary}
	ExecDos::Exec /NOUNLOAD /ASYNC `"$EXEDIR\App\FontForge\bin\VcXsrv\vcxsrv.exe" :11 -multiwindow -clipboard -silent-dup-error -notrayicon` '' ''
	Pop $R0
	ExecDos::Exec `"$EXEDIR\App\FontForge\bin\VcXsrv_util.exe" -wait` '' ''
	Pop $R0
!macroend

${SegmentPostPrimary}
	ExecDos::Exec `"$EXEDIR\App\FontForge\bin\VcXsrv_util.exe" -close` '' ''
	Pop $R0
	Delete "$TEMP\FontForgePortableTemp\CXSrv.0.log"
	RMDir "$TEMP\FontForgePortableTemp"
!macroend
