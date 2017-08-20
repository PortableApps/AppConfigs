!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_LEGACY_SMARTDEFRAGDRIVER
Var Exists_Services_SmartDefragBootTime
Var Exists_Services_SmartDefragDriver
Var Exists_SmartDefrag3_Update_Scheduled_Task
Var Exists_SmartDefrag_AutoAnalyze_Scheduled_Task
Var Exists_SmartDefrag_Update_Scheduled_Task


; ReadINIStrWithDefault 1.1 (2009-05-12)
;
; Substitutes a default value if the INI is undefined
; Copyright 2008-2009 John T. Haller of PortableApps.com
; Released under the BSD
;
; Usage: ${ReadINIStrWithDefault} OUTPUT_VALUE INI_FILENAME SECTION_NAME ENTRY_NAME DEFAULT_VALUE
;
; History:
; 1.1 (2009-05-12): Fixed error with $0 and $2 being swapped

Function ReadINIStrWithDefault
	;Start with a clean slate
	ClearErrors
	
	;Get our parameters
	Exch $0 ;DEFAULT_VALUE
	Exch
	Exch $1 ;ENTRY_NAME
	Exch 2
	Exch $2 ;SECTION_NAME
	Exch  3
	Exch $3 ;INI_FILENAME
	Push $4 ;OUTPUT_VALUE
	
	;Read from the INI
	ReadINIStr $4 $3 $2 $1
	IfErrors 0 +3
		StrCpy $4 $0
		ClearErrors

	;Keep the variable for last
	StrCpy $0 $4
	
	;Clear the stack
	Pop $4
	Pop $3
	Exch 2
	Pop $2
	Pop $1
	
	;Reset the last variable and leave our result on the stack
	Exch $0
FunctionEnd

!macro ReadINIStrWithDefault OUTPUT_VALUE INI_FILENAME SECTION_NAME ENTRY_NAME DEFAULT_VALUE
  Push `${INI_FILENAME}`
  Push `${SECTION_NAME}`
  Push `${ENTRY_NAME}`
  Push `${DEFAULT_VALUE}`
  Call ReadINIStrWithDefault
  Pop `${OUTPUT_VALUE}`
!macroend

!define ReadINIStrWithDefault '!insertmacro "ReadINIStrWithDefault"'


${SegmentInit}
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues	
	${ReadINIStrWithDefault} $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Installer" "Run" "true"
	
	${If} $R0 == "false"
	${OrIf} ${FileExists} "$EXEDIR\*.version"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		${ReadINIStrWithDefault} $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion" "0.0.0.0"
		${ReadINIStrWithDefault} $1 "$SETTINGSDIRECTORY\SmartDefragPortableSettings.ini" "SmartDefragPortableSettings" "InvalidPackageWarningShown" "0.0.0.0"
		${VersionCompare} $0 $1 $2
		${If} $2 == 1
		${OrIf} $R0 == "false"			
			MessageBox MB_OK|MB_ICONEXCLAMATION `Integrity Failure Warning: Smart Defrag Portable was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Please visit PortableApps.com to obtain the official release of this application to install or upgrade. If you wish to use this application in its current unsupported state, please click OK to continue.`
			WriteINIStr "$SETTINGSDIRECTORY\SmartDefragPortableSettings.ini" "SmartDefragPortableSettings" "InvalidPackageWarningShown" $0
			DeleteINISec "$EXEDIR\App\AppInfo\appinfo.ini" "Installer"
		${EndIf}
	${EndIf}
!macroend

${SegmentPrePrimary}
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragBootTime true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_SmartDefragDriver true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_SMARTDEFRAGDRIVER true
	${EndIf}

	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag3_Update"
		StrCpy $Exists_SmartDefrag3_Update_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_AutoAnalyze"
		StrCpy $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\SmartDefrag_Update"
		StrCpy $Exists_SmartDefrag_Update_Scheduled_Task true
	${EndIf}
	
	Rename "$WINDIR\Tasks\SmartDefrag3_Update.job" "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update.job" "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update.job" "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule.job" "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup.job" "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate.job" "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver.sys" "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys"
	Rename "$WINDIR\system32\SmartDefragBootTime.exe" "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension.dll" "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll"
!macroend

${SegmentPostPrimary}
	${IfNot} $Exists_LEGACY_SMARTDEFRAGDRIVER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_SMARTDEFRAGDRIVER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_SmartDefragDriver == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragDriver" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragDriver" $R0
			${EndIf}
		${EndIf}
	${EndIf}

	${IfNot} $Exists_Services_SmartDefragBootTime == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SmartDefragBootTime" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	
	${If} $Exists_SmartDefrag3_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag3_Update /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_AutoAnalyze_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_AutoAnalyze /f`
		Pop $0
	${EndIf}
	
	${If} $Exists_SmartDefrag_Update_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn SmartDefrag_Update /f`
		Pop $0
	${EndIf}	
	
	Delete "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Delete "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Delete "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag3_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag3_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag4_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag4_Update.job"
	Delete "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag5_Update-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag5_Update.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Schedule-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Schedule.job"
	Rename "$WINDIR\Tasks\SmartDefrag_Startup-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefrag_Startup.job"
	Rename "$WINDIR\Tasks\SmartDefragUpdate-BackUpBySmartDefragPortable.job" "$WINDIR\Tasks\SmartDefragUpdate.job"
	Delete "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Rename "$WINDIR\system32\drivers\SmartDefragDriver-BackUpBySmartDefragPortable.sys" "$WINDIR\system32\drivers\SmartDefragDriver.sys"
	Delete "$WINDIR\system32\SmartDefragBootTime.exe"
	Rename "$WINDIR\system32\SmartDefragBootTime-BackUpBySmartDefragPortable.exe" "$WINDIR\system32\SmartDefragBootTime.exe"
	;Delete "$WINDIR\system32\IObitSmartDefragExtension.dll"
	;Rename "$WINDIR\system32\IObitSmartDefragExtension-BackUpBySmartDefragPortable.dll" "$WINDIR\system32\IObitSmartDefragExtension.dll"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/infofiles/smartdefrag/isd2update.upt')i .r2"
!macroend