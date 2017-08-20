${SegmentFile}

;!ifdef NSIS_UNICODE
;	!addplugindir .\PluginsW
;!else ; NSIS_UNICODE
;	!addplugindir .\PluginsA
;!endif
!addplugindir "${PACKAGE}\App\AppInfo\Launcher\ChromePasswords\Release"
!addincludedir "${PACKAGE}\App\AppInfo\Launcher"
!include "dialogs.nsh"
!include "PluginsEx.nsh"

!define LAUNCHERLANGUAGE "English"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROFILEDIRECTORY
Var Incognito
Var PortablePasswords
Var EncryptPortablePasswords
Var MasterPassword

; Imports all passwords stored in Passwords Portable for use in Iron by decrypting them with the master password and then re-encrypting them with the local user account.
Function ImportPasswords
	${If} $PortablePasswords != "true"
		Return
	${EndIf}

	FindFirst $8 $7 "$PROFILEDIRECTORY\*"
	${While} $7 != ""
		${If} ${FileExists} "$PROFILEDIRECTORY\$7\Portable Passwords"
		${AndIf} ${FileExists} "$PROFILEDIRECTORY\$7\Login Data"
			${ChromePasswords::ImportPasswords} "$PROFILEDIRECTORY\$7\Portable Passwords" "$PROFILEDIRECTORY\$7\Login Data" $MasterPassword
		${EndIf}
		FindNext $8 $7
	${EndWhile}
	FindClose $8
FunctionEnd

; Exports all passwords stored in Login Data by decrypting using the local user account and encrypting using our master password.
Function ExportPasswords
	${If} $PortablePasswords != "true"
		Return
	${EndIf}

	FindFirst $8 $7 "$PROFILEDIRECTORY\*"
	${While} $7 != ""
		${If} ${FileExists} "$PROFILEDIRECTORY\$7\Login Data"
			${ChromePasswords::ExportPasswords} "$PROFILEDIRECTORY\$7\Login Data" "$PROFILEDIRECTORY\$7\Portable Passwords" $MasterPassword
		${EndIf}
		FindNext $8 $7
	${EndWhile}
	FindClose $8
FunctionEnd

${SegmentPre}
	StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\IronPortableData"
	${ReadUserConfig} $Incognito Incognito
	${ReadUserConfig} $PortablePasswords PortablePasswords
	${ReadUserConfig} $EncryptPortablePasswords EncryptPortablePasswords
!macroend

${SegmentPrePrimary}
	StrCpy $MasterPassword ""

	${If} $PortablePasswords == "true"
	${AndIf} $EncryptPortablePasswords != "false"
		${InputPwdBox} "$(LauncherOptionsHeader)" "$(LauncherOptionsIntro)" "" "32767" "$(LauncherOptionsOK)" "$(LauncherOptionsCancel)" 0
		StrCpy $MasterPassword $0

		${If} $0 == ""
			Abort
		${EndIf}

		${ChromePasswords::HashPassword} $MasterPassword
		Pop $0

		${If} $0 == ""
			MessageBox MB_ICONEXCLAMATION `$(LauncherDLLError)`
			StrCpy $PortablePasswords "false"
		${Else}
			${If} ${FileExists} "$PROFILEDIRECTORY\masterpassword.hash"
				FileOpen $2 "$PROFILEDIRECTORY\masterpassword.hash" r
				FileRead $2 $1
				FileClose $2

				${If} $0 != $1
					MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherInvalidPassword)`
					Abort
				${EndIf}
			${Else}

				FileOpen $1 "$PROFILEDIRECTORY\masterpassword.hash" w
				FileWrite $1 $0
				FileClose $1
			${EndIf}
		${EndIf}
	${EndIf}
	
	Call ImportPasswords
!macroend

${SegmentPreExec}
	${If} $Incognito == true
		StrCpy $ExecString "$ExecString --incognito"
	${EndIf}
	# Java support
	${If} ${FileExists} "$JavaDirectory\Bin\plugin2\npjp2.dll"
		StrCpy $ExecString '$ExecString --extra-plugin-dir="$JavaDirectory\bin\plugin2"'
	${ElseIf} ${FileExists} "$JavaDirectory\Bin\New_Plugin\npjp2.dll"
		StrCpy $ExecString '$ExecString --extra-plugin-dir="$JavaDirectory\bin\new_plugin"'
	${EndIf}
	
	${GetParent} $EXEDIR $1
	${If} ${FileExists} "$1\CommonFiles\Silverlight\files\*.*"
		StrCpy $ExecString `$ExecString --extra-plugin-dir="$1\CommonFiles\Silverlight\files"`
	${EndIf}
	${If} ${FileExists} "$1\CommonFiles\Flash\files\*.*"
		StrCpy $ExecString `$ExecString --extra-plugin-dir="$1\CommonFiles\Flash\files"`
	${EndIf}
	${If} ${FileExists} "$1\CommonFiles\BrowserPlugins\*.*"
		StrCpy $ExecString `$ExecString --extra-plugin-dir="$1\CommonFiles\BrowserPlugins"`
	${EndIf}
!macroend

${SegmentPost}
	Call ExportPasswords
!macroend
