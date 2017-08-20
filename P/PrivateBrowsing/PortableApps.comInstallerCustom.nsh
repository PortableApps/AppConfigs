!macro CustomCodePreInstall
	IfFileExists "$INSTDIR\Data\profile\extensions\{bf23285b-1e78-4d44-8493-bd495c5e78f3}\chrome.manifest" "" CustomCodePreInstallEnd
		RMDir /r "$INSTDIR\Data\profile\extensions\{bf23285b-1e78-4d44-8493-bd495c5e78f3}"
		CreateDirectory "$INSTDIR\Data\profile\extensions\{bf23285b-1e78-4d44-8493-bd495c5e78f3}"
		CopyFiles "$INSTDIR\App\DefaultData\profile\extensions\{bf23285b-1e78-4d44-8493-bd495c5e78f3}\*.*" "$INSTDIR\Data\profile\extensions\{bf23285b-1e78-4d44-8493-bd495c5e78f3}"
	CustomCodePreInstallEnd:
!macroend