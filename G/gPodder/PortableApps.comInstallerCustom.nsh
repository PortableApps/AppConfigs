!macro CustomCodePostInstall
	${IfNot} ${FileExists} $INSTDIR\Data\settings\gPodderPortableSettings.ini
		CreateDirectory $INSTDIR\Data
		CopyFiles /SILENT $INSTDIR\App\DefaultData\*.* $INSTDIR\Data
		CreateDirectory $INSTDIR\Data\settings
	${EndIf}
	${If} ${FileExists} $INSTDIR\Data\downloads
		CreateDirectory $INSTDIR\Data\config
		${If} ${FileExists} $INSTDIR\Data\config\downloads
			CopyFiles /SILENT $INSTDIR\Data\downloads\*.* $INSTDIR\Data\config\downloads
			RMDir /r $INSTDIR\Data\downloads
		${Else}
			Rename $INSTDIR\Data\downloads $INSTDIR\Data\config\Downloads
		${EndIf}
	${EndIf}
	
	StrCmp $LANGUAGE "1029" 0 +3 ;Czech
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "cs"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1030" 0 +3 ;Danish
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "da"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1031" 0 +3 ;German
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "de"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1034" 0 +3 ;Spanish
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "es"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "3082" 0 +3 ;SpanishInternational
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "es"
		Goto CustomCodePostInstallEnd		
	StrCmp $LANGUAGE "1035" 0 +3 ;Finnish
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "fi"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1036" 0 +3 ;French
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "fr"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1110" 0 +3 ;Galician
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "gl"
		Goto CustomCodePostInstallEnd		
	StrCmp $LANGUAGE "1037" 0 +3 ;Hebrew
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "he"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1040" 0 +3 ;Italian
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "it"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1044" 0 +3 ;Norwegian
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "nb"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1043" 0 +3 ;Dutch
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "nl"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1045" 0 +3 ;Polish
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "pl"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1046" 0 +3 ;Portuguese (Brazilian)
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "pt_BR"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "2070" 0 +3 ;Portuguese
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "pt"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1048" 0 +3 ;Romanian
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "ro"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1049" 0 +3 ;Russian
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "ru_RU"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1053" 0 +3 ;Swedish
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "sv"
		Goto CustomCodePostInstallEnd
	StrCmp $LANGUAGE "1058" 0 +3 ;Ukrainian
		WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "uk"
		Goto CustomCodePostInstallEnd
	WriteINIStr $INSTDIR\Data\settings\gPodderPortableSettings.ini "gPodderPortableSettings" "Language" "en" ;=== Fallback to English
	CustomCodePostInstallEnd:
!macroend