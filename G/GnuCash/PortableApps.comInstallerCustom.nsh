!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data"
		CreateDirectory "$INSTDIR\Data\Temp"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "2.4.3.0" $1
		${If} $1 == 2
			${If} ${FileExists} "$INSTDIR\Data\Settings\GnuCashPortableSettings.ini"
				WriteINIStr "$INSTDIR\Data\Settings\GnuCashPortableSettings.ini" "GnuCashPortableSettings" "WarnedNoAdmin" ""
			${EndIf}
		${EndIf}
		${VersionCompare} "$0" "3.2.0.0" $1
		${If} $1 == 2
			${If} ${FileExists} "$INSTDIR\Data\Profile\*.*"
				${IfNot} ${FileExists} "$INSTDIR\Data\GNCDataHome\books\*.*"
					;Upgrade portable data to 3.x format
					CreateDirectory "$INSTDIR\Data\GNCDataHome"
					CopyFiles /SILENT "$INSTDIR\Data\Profile\*.*" "$INSTDIR\Data\GNCDataHome"
					${IfNot} ${FileExists} "$INSTDIR\Data\GNCDataHome\saved-reports*"
					${AndIf} ${FileExists} "$PROFILE\.gnucash\saved-reports*"
						;Copy report files accidentally left locally
						CopyFiles /SILENT "$PROFILE\.gnucash\saved-reports*" "$INSTDIR\Data\GNCDataHome"
						MessageBox MB_OK|MB_ICONINFORMATION "Your GnuCash custom reports were copied from '$PROFILE\.gnucash' to GnuCash Portable.  If they were previously saved there in error, you can remove the files using Windows Explorer."
					${EndIf}
				${EndIf}
			${Else}
				;We have no previous settings done portably
				${If} ${FileExists} "$PROFILE\.gnucash\*.*"
				${AndIfNot} ${FileExists} "$INSTDIR\Data\GNCDataHome\books\*.*"
					;Copy 2.x data accidentally stored locally to portable
					CreateDirectory "$INSTDIR\Data\GNCDataHome"
					CopyFiles /SILENT "$PROFILE\.gnucash\*.*" "$INSTDIR\Data\GNCDataHome"
					MessageBox MB_OK|MB_ICONINFORMATION "Your GnuCash data was copied from '$PROFILE\.gnucash' to GnuCash Portable.  If it was previously saved there in error, you can remove the files using Windows Explorer."
				${ElseIf} ${FileExists} "$APPDATA\GnuCash\*.*"
				${AndIfNot} ${FileExists} "$INSTDIR\Data\GNCDataHome\books\*.*"
					;Copy 3.x data accidentally stored locally to portable
					CreateDirectory "$INSTDIR\Data\GNCDataHome"
					CopyFiles /SILENT "$APPDATA\GnuCash\*.*" "$INSTDIR\Data\GNCDataHome"
					MessageBox MB_OK|MB_ICONINFORMATION "Your GnuCash data was copied from '$APPDATA\GnuCash' to GnuCash Portable.  If it was previously saved there in error, you can remove the files using Windows Explorer."
				${EndIf}
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$INSTDIR\Data\settings\GnuCash.reg"
			CreateDirectory "$INSTDIR\Data\GNCDataHome"
			CreateDirectory "$INSTDIR\Data\GTKDataHome"
			CreateDirectory "$INSTDIR\Data\Profile"
		${EndIf}
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\GTKDataHome"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\GTKDataHome\settings.ini"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\GTKDataHome\*.*" "$INSTDIR\Data\GTKDataHome"
	${EndIf}
!macroend
