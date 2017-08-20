!macro CustomCodePreInstall
	CreateDirectory "$INSTDIR\CustomPreserve"
	Rename "$INSTDIR\App\Firefox\plugins" "$INSTDIR\CustomPreserve\plugins"
	Rename "$INSTDIR\App\Firefox\searchplugins" "$INSTDIR\CustomPreserve\searchplugins"
	Rename "$INSTDIR\App\Firefox\components" "$INSTDIR\CustomPreserve\components"
	Rename "$INSTDIR\App\Firefox64\plugins" "$INSTDIR\CustomPreserve\plugins64"
	Rename "$INSTDIR\App\Firefox64\searchplugins" "$INSTDIR\CustomPreserve\searchplugins64"
	Rename "$INSTDIR\App\Firefox64\components" "$INSTDIR\CustomPreserve\components64"
	RMDir /r "$INSTDIR\App\Firefox"
!macroend

!macro CustomCodePostInstall
	Delete "$INSTDIR\App\setup.exe"
	RMDir /r "$INSTDIR\App\Firefox"
	Rename "$INSTDIR\App\core" "$INSTDIR\App\Firefox"
	Rename "$INSTDIR\App\64files\core" "$INSTDIR\App\Firefox64"
	RMDir /r "$INSTDIR\App\64files"
	CopyFiles "$INSTDIR\CustomPreserve\plugins\*.*" "$INSTDIR\App\Firefox\plugins"
	CopyFiles "$INSTDIR\CustomPreserve\searchplugins\*.*" "$INSTDIR\App\Firefox\searchplugins"
	CopyFiles "$INSTDIR\CustomPreserve\components\*.*" "$INSTDIR\App\Firefox\components"
	CopyFiles "$INSTDIR\CustomPreserve\plugins64\*.*" "$INSTDIR\App\Firefox64\plugins"
	CopyFiles "$INSTDIR\CustomPreserve\searchplugins64\*.*" "$INSTDIR\App\Firefox64\searchplugins"
	CopyFiles "$INSTDIR\CustomPreserve\components64\*.*" "$INSTDIR\App\Firefox64\components"
	RMDir /r "$INSTDIR\CustomPreserve"
!macroend