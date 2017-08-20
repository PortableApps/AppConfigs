!macro CustomCodePostInstall
	CreateDirectory "$INSTDIR\Data\settings"
	WriteINIStr "$INSTDIR\Data\settings\SunbirdPortableSettings.ini" "SunbirdPortableSettings" "AgreedToLicense" "1.1"
!macroend