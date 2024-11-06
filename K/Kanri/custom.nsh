${SegmentFile}

${Segment.OnInit}
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	ReadRegStr $2 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $2 < 9200 ;Windows 8.0+
	${OrIf} $0 == 0 ;or 32-bit
		StrCpy $AppName "AutoDrum"
		${If} ${IsWin2000}
			StrCpy $1 2000
		${ElseIf} ${IsWinXP}
			StrCpy $1 XP
		${ElseIf} ${IsWin2003}
			StrCpy $1 2003
		${ElseIf} ${IsWinVista}
			StrCpy $1 Vista
		${ElseIf} ${IsWin2008}
			StrCpy $1 2008
		${ElseIf} ${IsWin7}
			StrCpy $1 "7 32-bit"
		${ElseIf} ${IsWin2008R2}
			StrCpy $1 "2008 R2"
		${ElseIf} ${IsWin8}
			${If} $2 < 10000 ;Windows 7/8
				StrCpy $1 "8 32-bit"
			${Else}
				StrCpy $1 "10 32-bit"
			${EndIf}
		${ElseIf} ${IsWin2012}
			StrCpy $1 2012
		${Else}
			StrCpy $1 "Pre-Win10"
		${EndIf}	
		StrCpy $0 "8.0 64-bit"
		MessageBox MB_OK|MB_ICONSTOP "$(LauncherIncompatibleMinOS)"
		Abort
	${EndIf}
	
	${registry::KeyExists} "HKLM\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" $R0
	${registry::KeyExists} "HKCU\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" $R1

	${If} $R0 == -1
	${AndIf} $R1 == -1
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `This app requires Microsoft Edge WebView2 on the local machine which is not currently installed. Would you like to install it now?` IDYES CustomWebView2CheckGotoURL IDNO CustomWebView2CheckGotoAbort

			CustomWebView2CheckGotoURL:
			MessageBox MB_OK|MB_ICONINFORMATION `The Microsoft Edge WebView2 installer will now run. When complete, you can run the app again.` IDYES CustomWebView2CheckGotoURL IDNO CustomWebView2CheckGotoAbort
			ExecShell "open" `"$EXEDIR\App\Kanri\MicrosoftEdgeWebview2Setup.exe"`
						
			CustomWebView2CheckGotoAbort:
			Abort
	${EndIf}
	
	ReadRegStr $2 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	${If} $2 < 9600 ;Windows 8.0
		${registry::KeyExists} "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" $R0
		${If} $R0 == -1
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `This app requires VC Runtime 14.0 or later. Would you like to install it now?` IDYES CustomVCRCheckGotoURL IDNO CustomVCRCheckGotoAbort

				CustomVCRCheckGotoURL:
				MessageBox MB_OK|MB_ICONINFORMATION `The Microsoft VC Runtime installer will now download. When complete, run it to install and then you can run the app again.` IDYES CustomVCRCheckGotoURL IDNO CustomWebView2CheckGotoAbort
				ExecShell "open" `"https://aka.ms/vs/17/release/vc_redist.x64.exe"`
							
				CustomVCRCheckGotoAbort:
				Abort
		${EndIf}
	${EndIf}
!macroend