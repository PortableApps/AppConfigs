!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

Var Exists_HKUDefaultLocalization
Var Exists_HKUDefaultSNL
Var Exists_Services_SDUpdateService

${SegmentPrePrimary}
	;=== START INTEGRITY CHECK 1.0
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues
	;Designed to not require ReadINIStrWithDefault which is not included in the PA.c Launcher code
	
	${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
		${If} ${FileExists} "$EXEDIR\App\AppInfo\pac_installer_log.ini"
			ReadINIStr $R0 "$EXEDIR\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info2"
			${If} $R0 == "This file was generated by the PortableApps.com Installer wizard and modified by the official PortableApps.com Installer TM Rare Ideas, LLC as the app was installed."
				StrCpy $R1 "true"
			${Else}
				StrCpy $R1 "false"
			${EndIf}
		${Else}
			StrCpy $R1 "false"
		${EndIf}
	${Else}
		StrCpy $R1 "true"
	${EndIf}
	
	${If} $R1 == "false"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		ClearErrors
		ReadINIStr $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${If} ${Errors}
		${OrIf} $0 == ""
			StrCpy $0 "0.0.0.1"
			ClearErrors
		${EndIf}

		ClearErrors
		ReadINIStr $1 "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown"
		${If} ${Errors}
		${OrIf} $1 == ""
			StrCpy $1 "0.0.0.0"
			ClearErrors
		${EndIf}

		${VersionCompare} $0 $1 $2
		${If} $2 == 1		
			MessageBox MB_OK|MB_ICONEXCLAMATION `Integrity Failure Warning: ${NamePortable} was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Please visit PortableApps.com to obtain the official release of this application to install or upgrade. If you wish to use this application in its current unsupported state, please click OK to continue.`
			WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown" $0
		${EndIf}
	${EndIf}
	;=== END INTEGRITY CHECK
	
    ${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
    ${If} $R0 = 0
        StrCpy $Exists_Services_SDUpdateService true
    ${EndIf}

    ${registry::KeyExists} "HKU\.DEFAULT\Software\Safer Networking Limited\Localization" $R0
    ${If} $R0 = 0
        StrCpy $Exists_HKUDefaultLocalization true
    ${EndIf}

    ${registry::KeyExists} "HKU\.DEFAULT\Software\Safer Networking Limited" $R0
    ${If} $R0 = 0
        StrCpy $Exists_HKUDefaultSNL true
    ${EndIf}
!macroend

${SegmentPostPrimary}
    ${IfNot} $Exists_HKUDefaultSNL == true
        ${registry::DeleteKey} "HKU\.DEFAULT\Software\Safer Networking Limited" $R0
    ${Else}
        ${IfNot} $Exists_HKUDefaultLocalization == true
            ${registry::DeleteKey} "HKU\.DEFAULT\Software\Safer Networking Limited\Localization" $R0	
        ${EndIf}
    ${EndIf}
    ${IfNot} $Exists_Services_SDUpdateService == true
        ${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
        ${If} $R0 = 0
            AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\SDUpdateService" "(BU)" "FullAccess"
            Pop $R0
            ${If} $R0 == error
                Pop $R0
                ;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
            ${Else}
                ${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\SDUpdateService" $R0
            ${EndIf}
        ${EndIf}
    ${EndIf}
!macroend
