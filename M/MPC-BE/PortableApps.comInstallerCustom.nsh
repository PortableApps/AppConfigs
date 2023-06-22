!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "1.6.7.1" $R0
		${If} $R0 == 2
			Rename "$INSTDIR\App\MPC-BE\history.mpc_lst" "$INSTDIR\Data\settings\history.mpc_lst"
		${EndIf}
	${EndIf}
!macroend