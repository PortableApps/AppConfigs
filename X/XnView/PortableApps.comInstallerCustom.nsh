!macro CustomCodePreInstall
	; Remove pre-PAL folders
	${If} ${FileExists} "$INSTDIR\Data\Files\*.*"
		RMDir /r "$INSTDIR\Data\Folders"
		RMDir /r "$INSTDIR\Data\Files"
		RMDir /r "$INSTDIR\Data\Registry"
	${EndIf}
	; move cache folder to Data
	${If} ${FileExists} "$INSTDIR\App\XnView\cache\*.*"
		CreateDirectory "$INSTDIR\Data\cache"
		CopyFiles /SILENT "$INSTDIR\App\XnView\cache\*.*" "$INSTDIR\Data\cache"
	${EndIf}
	; Delete extraneous cache folder from wrong location
	${If} ${FileExists} "$INSTDIR\App\cache\*.*"
		RMDir /r "$INSTDIR\App\cache"
	${EndIf}
!macroend

!macro CustomCodePostInstall
	; add Data\Settings so settings aren't lost on upgrade to PAL
	${If} ${FileExists} "$INSTDIR\Data\xnview.ini"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\Settings\*.*"
		CreateDirectory "$INSTDIR\Data\Settings"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\Settings\*.*" "$INSTDIR\Data\Settings"
	${EndIf}
!macroend