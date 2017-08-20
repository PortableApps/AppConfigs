${SegmentFile}

;Var AllowUnprivilegedConnections

;${SegmentInit}
;    ${If} $Bits = 64
;        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\ProcessHacker\x64"
;    ${Else}
;        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\ProcessHacker\x86"
;    ${EndIf}
	
;	${ReadUserConfig} $AllowUnprivilegedConnections AllowUnprivilegedConnections
;!macroend

;${SegmentPrePrimary}
;	ExecWait "sc start KProcessHacker2"
;	
;	${If} $AllowUnprivilegedConnections == "true"
;		${registry::Write} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KProcessHacker2\Parameters" "SecurityLevel" "0" "REG_DWORD" $R9 ; path, value, string, type, return
;		ExecWait "sc stop KProcessHacker2" ; restart the service so changes take effect
;		ExecWait "sc start KProcessHacker2"
;	${EndIf}
;!macroend
;
;${SegmentPost}
;	ExecWait "sc stop KProcessHacker2"
;!macroend

${SegmentPostPrimary}
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://processhacker.sourceforge.net/update.php')i .r2"
!macroend