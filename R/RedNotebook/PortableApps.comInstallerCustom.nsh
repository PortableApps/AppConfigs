Var UpgradeFromVersionWithoutFonts

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\user\*.*"
		Rename "$INSTDIR\Data\user" "$INSTDIR\Data\.rednotebook"
		${ConfigWrite} "$INSTDIR\Data\.rednotebook\configuration.cfg" "dataDir=" "$INSTDIR\Data\.rednotebook\data" $R0
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\.rednotebook\*.*"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\usersettings\*.*"
		CreateDirectory "$INSTDIR\Data\usersettings"
		Rename "$INSTDIR\Data\.rednotebook\templates" "$INSTDIR\Data\usersettings\templates"
		Rename "$INSTDIR\Data\.rednotebook\tmp" "$INSTDIR\Data\usersettings\tmp"
		Rename "$INSTDIR\Data\.rednotebook\configuration.cfg" "$INSTDIR\Data\usersettings\configuration.cfg"
		Rename "$INSTDIR\Data\.rednotebook\rednotebook.log" "$INSTDIR\Data\usersettings\rednotebook.log"
		CopyFiles /SILENT "$INSTDIR\Data\.rednotebook\data\*.*" "$INSTDIR\Data\usersettings\data"
		RMDir /r "$INSTDIR\Data\.rednotebook"
		${ConfigWrite} "$INSTDIR\Data\usersettings\configuration.cfg" "dataDir=" "../../Data/usersettings/data" $R0
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\.rednotebook\*.*"
	${AndIf} ${FileExists} "$INSTDIR\Data\usersettings\*.*"
		CopyFiles /SILENT "$INSTDIR\Data\.rednotebook\data\*.*" "$INSTDIR\Data\usersettings\data"
		RMDir /r "$INSTDIR\Data\.rednotebook"
		${ConfigWrite} "$INSTDIR\Data\usersettings\configuration.cfg" "dataDir=" "../../Data/usersettings/data" $R0
	${EndIf}
	# Handle upgrades from versions without fonts
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
	${AndIf} ${FileExists} "$INSTDIR\Data\usersettings\*.*"
		ReadINIStr $R2 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} "$R2" "1.3.0.4" $9 # 1.3.0.4 is proposed Rev 1 number
		${If} $9 == "2"
			StrCpy $UpgradeFromVersionWithoutFonts true		
		${EndIf}
	${EndIf}	
!macroend

!macro CustomCodePostInstall
	${ConfigWrite} "$INSTDIR\App\RedNotebook\files\default.cfg" "portable=" "1" $R0
	${ConfigWrite} "$INSTDIR\App\RedNotebook\files\default.cfg" "userDir=" "../../Data/usersettings" $R0
	${If} ${FileExists} "$INSTDIR\App\Rednotebook\etc\fonts\fonts.conf"
		Delete "$INSTDIR\App\Rednotebook\etc\fonts\fonts.conf"
	${EndIf}	
	${If} $UpgradeFromVersionWithoutFonts == true
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\fonts.conf" "$INSTDIR\Data\"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\.recently-used.xbel" "$INSTDIR\Data\"
	${EndIf}	
!macroend
# this custom installer was created mainly by  John T Haller and Gord Caswell
# I (Patrick Powell) Had little to do with it but I tried