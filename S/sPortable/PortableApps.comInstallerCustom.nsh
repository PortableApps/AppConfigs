!macro CustomCodePreInstall
	;Check for clean upgrade
	${GetParent} "$INSTDIR" $0 ;PortableApps Directory
	${If} ${FileExists} "$0\SkypePortable\SkypePortable.exe"
	${AndIfNot} ${FileExists} "$INSTDIR\App\*.*"
		;Copy existing install and data in to be upgraded
		CopyFiles /SILENT  "$0\SkypePortable\*.*" "$INSTDIR"
		Rename "$INSTDIR\SkypePortable.exe" "$INSTDIR\sPortable.exe"
		Rename "$INSTDIR\SkypePortable.ini" "$INSTDIR\sPortable.ini"
		
		;Make a backup of the existing version
		CreateDirectory "$INSTDIR\Data\SkypePortableBackup"
		CopyFiles /SILENT  "$0\SkypePortable\*.*" "$INSTDIR\Data\SkypePortableBackup"
	
		;Remove the old version
		RMDir /r "$0\SkypePortable"
	${EndIf}
!macroend

!macro CustomCodePostInstall
	;nsExec::ExecToStack `"$INSTDIR\App\bin\upx.exe" -d "$INSTDIR\App\SkypeInstaller\SkypeSetupFull.exe"`
	;Pop $R1 ;exit code
	;Pop $R2	;UPX output
	
	ReadINIStr $0 "$INSTDIR\App\AppInfo\installer.ini" "DownloadFiles" "DownloadFilename"
	nsExec::Exec `"$INSTDIR\App\bin\7za.exe" x "$INSTDIR\App\SkypeInstaller\$0" -o"$INSTDIR\App\Skype\Phone"`
	Pop $R1 ;exit code
	
	;CreateDirectory "$INSTDIR\App\Skype\Apps\login"
	
	;nsExec::Exec `"$INSTDIR\App\bin\7za.exe" x "$INSTDIR\App\Skype\Phone\Login.cab" -o"$INSTDIR\App\Skype\Apps\login"`
	;Pop $R1 ;exit code
	
	RMDir /r "$INSTDIR\App\bin"
	RMDir /r "$INSTDIR\App\SkypeInstaller"

	Rename "$INSTDIR\App\Skype\Phone\Skype4COM.dll.65B9650E_D4EA_458D_AE52_454823D78F93" "$INSTDIR\App\Skype\Phone\Skype4COM.dll"
	Rename "$INSTDIR\App\Skype\Phone\F_CENTRAL_msvcp120_x86.194841A2_D0F2_3B96_9F71_05BA91BEA0FA" "$INSTDIR\App\Skype\Phone\msvcp120.dll"
	Rename "$INSTDIR\App\Skype\Phone\F_CENTRAL_msvcr120_x86.194841A2_D0F2_3B96_9F71_05BA91BEA0FA" "$INSTDIR\App\Skype\Phone\msvcr120.dll"
	Rename "$INSTDIR\App\Skype\Phone\F_CENTRAL_vccorlib120_x86.194841A2_D0F2_3B96_9F71_05BA91BEA0FA" "$INSTDIR\App\Skype\Phone\vccorlib120.dll"
	Rename "$INSTDIR\App\Skype\Phone\SkypeThirdPartyAttributions" "$INSTDIR\App\Skype\Phone\third-party_attributions.txt"
	
	
	FindFirst $0 $1 "$INSTDIR\App\Skype\Phone\api*.dll"
	CustomCodePostInstallLoopStart:
		StrCmp $1 "" CustomCodePostInstallLoopDone
		${WordReplace} "$1" "_" "-" "+" $2
		Rename "$INSTDIR\App\Skype\Phone\$1" "$INSTDIR\App\Skype\Phone\$2"
		FindNext $0 $1
		Goto CustomCodePostInstallLoopStart
	CustomCodePostInstallLoopDone:
	FindClose $0
	
	#Rename "api_ms_win_core_console_l1_1_0.dll" "api-ms-win-core-console-l1-1-0.dll"
	#Rename "api_ms_win_core_datetime_l1_1_0.dll" "api-ms-win-core-datetime-l1-1-0.dll"
	#Rename "api_ms_win_core_debug_l1_1_0.dll" "api-ms-win-core-debug-l1-1-0.dll"
	#Rename "api_ms_win_core_errorhandling_l1_1_0.dll" ".dll"
	
	Delete "$INSTDIR\App\Skype\Phone\SkypeDesktopIni"
	Delete "$INSTDIR\App\Skype\Phone\Updater.exe"
	Delete "$INSTDIR\App\Skype\Phone\Updater.dll"
	Delete "$INSTDIR\App\Skype\Phone\SkypeBrowserHost.exe.8BC8B74C_C7CF_4DDC_9B88_774D97DA1209"
	;Delete "$INSTDIR\App\Skype\Phone\log*"
!macroend
