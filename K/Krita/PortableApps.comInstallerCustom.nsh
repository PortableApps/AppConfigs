Var UpgradeLangVar

!macro CusomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\AppInfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$0" "3.1.1.0" $1
		${If} $1 == "2"  ;$0 is older than
			StrCpy $UpgradeLangVar "$0"
		${EndIf}
	${EndIf}
!macroend


!macro CustomCodePostInstall
	${VersionCompare} "$UpgradeLangVar" "3.1.1.0" $1
	${If} $1 == "2"  ;$0 is older than
		${If} ${FileExists} "$INSTDIR\Data\*.*"
			CopyFiles "$INSTDIR\App\DefaultData\klanguageoverridesrc" "$INSTDIR\Data"
		${EndIf}
	${EndIf}
!macroend