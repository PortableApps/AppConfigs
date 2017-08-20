!macro CustomCodePostInstall

		${If} ${FileExists} $INSTDIR\Data\settings\xmplay.ini
			Rename $INSTDIR\Data\settings $INSTDIR\Data\xmplay
			CreateDirectory $INSTDIR\Data\settings
			Rename $INSTDIR\Data\xmplay\XMPlayPortableSettings.ini $INSTDIR\Data\settings\XMPlayPortableSettings.ini
			Sleep 100
			ReadINIStr $0 $INSTDIR\Data\settings\XMPlayPortableSettings.ini XMPlayPortableSettings LastPath
			${IfNot} $0 == ""
				WriteINIStr $INSTDIR\Data\settings\XMPlayPortableSettings.ini XMPlayPortableSettings LastDirectory \$0
				DeleteINIStr $INSTDIR\Data\settings\XMPlayPortableSettings.ini XMPlayPortableSettings LastPath
			${EndIf}
		${EndIf}

!macroend
