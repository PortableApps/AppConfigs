${SegmentFile}


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

Var CUSTOM_Exists_IobitUninstaller_Scheduled_Task
Var CUSTOM_Exists_IobitUninstaller_Scheduled_Task_User
Var CUSTOM_LoggedInUser

${SegmentPrePrimary}
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues	
	${ReadINIStrWithDefault} $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Installer" "Run" "true"
	${ReadINIStrWithDefault} $R1 "$EXEDIR\App\AppInfo\appinfo.ini" "PortableApps.comInstaller" "InstallIntegrityCheck" "false"
	
	${If} $R0 == "false"
	${OrIf} $R1 == "false"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		${ReadINIStrWithDefault} $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion" "0.0.0.0"
		${ReadINIStrWithDefault} $1 "$EXEDIR\Data\settings\IObitUninstallerPortableSettings.ini" "IObitUninstallerPortableSettings" "InvalidPackageWarningShown" "0.0.0.0"
		${VersionCompare} $0 $1 $2
		${If} $2 == 1		
			MessageBox MB_OK|MB_ICONEXCLAMATION `Integrity Failure Warning: IOBit Uninstaller Portable was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Please visit PortableApps.com to obtain the official release of this application to install or upgrade. If you wish to use this application in its current unsupported state, please click OK to continue.`
			WriteINIStr "$EXEDIR\Data\settings\IObitUninstallerPortableSettings.ini" "IObitUninstallerPortableSettings" "InvalidPackageWarningShown" $0
		${EndIf}
	${EndIf}

	System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
	StrCpy $CUSTOM_LoggedInUser $0

	${If} ${FileExists} "$SYSDIR\Tasks\Uninstaller_SkipUac_$CUSTOM_LoggedInUser"
		StrCpy $CUSTOM_Exists_IobitUninstaller_Scheduled_Task_User true
	${EndIf}
	
	${If} ${FileExists} "$SYSDIR\Tasks\Uninstaller_SkipUac_Administrator"
		StrCpy $CUSTOM_Exists_IobitUninstaller_Scheduled_Task true
	${EndIf}
!macroend


${SegmentPostPrimary}
	Delete $DataDirectory\uninstaller\SoftwareCache.ini
	
	System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
	
	${If} $CUSTOM_Exists_SmartDefrag_Scheduled_Task_User != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn Uninstaller_SkipUac_$CUSTOM_LoggedInUser /f`
		Pop $0
	${EndIf}
	
	${If} $CUSTOM_Exists_SmartDefrag_Scheduled_Task != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn Uninstaller_SkipUac_Administrator /f`
		Pop $0
	${EndIf}
	
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller3/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller4/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller5/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://download.iobit.com/uninstaller6/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/dl/uninstaller/UninstallRote.dbd')i .r2"
	System::Call "wininet::DeleteUrlCacheEntryW(t'http://update.iobit.com/dl/uninstaller/uninstall_qdb.dbd')i .r2"
!macroend