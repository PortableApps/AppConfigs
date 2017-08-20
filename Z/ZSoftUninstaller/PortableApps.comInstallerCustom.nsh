!macro CustomCodePreInstall
	${If} ${FileExists} $InstDir\App\ZSoftUninstaller\*.dat
		Rename $InstDir\App\ZSoftUninstaller\*.dat $InstDir\Data\*.dat
		${If} ${FileExists} $InstDir\App\ZSoftUninstaller\logs
			CreateDirectory $InstDir\Data\logs
			Rename $InstDir\App\ZSoftUninstaller\logs\*.* $InstDir\Data\logs
			RMDir $InstDir\App\ZSoftUninstaller\logs
		${EndIf}
		${If} ${FileExists} $InstDir\App\ZSoftUninstaller\LogBackups
			CreateDirectory $InstDir\Data\LogBackups
			Rename $InstDir\App\ZSoftUninstaller\LogBackups\*.* $InstDir\Data\LogBackups
			RMDir $InstDir\App\ZSoftUninstaller\LogBackups
		${EndIf}
		${If} ${FileExists} $InstDir\App\ZSoftUninstaller\PostUninstall
			CreateDirectory $InstDir\Data\PostUninstall
			Rename $InstDir\App\ZSoftUninstaller\PostUninstall\*.* $InstDir\Data\PostUninstall
			RMDir $InstDir\App\ZSoftUninstaller\PostUninstall
		${EndIf}
		${If} ${FileExists} $InstDir\App\ZSoftUninstaller\PostUninstallRegBackup
			CreateDirectory $InstDir\Data\PostUninstallRegBackup
			Rename $InstDir\App\ZSoftUninstaller\PostUninstallRegBackup\*.* $InstDir\Data\PostUninstallRegBackup
			RMDir $InstDir\App\ZSoftUninstaller\PostUninstallRegBackup
		${EndIf}
	${EndIf}
!macroend

