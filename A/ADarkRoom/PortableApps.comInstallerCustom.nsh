!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\ADarkRoomSettings\file__0.localstorage"
		Rename "$INSTDIR\Data\ADarkRoomSettings\file__0.localstorage" "$INSTDIR\Data\ADarkRoomSettings\chrome-extension_iaaibobcfjaegfehbgdhhahebcfcnmdb_0.localstorage"
		Rename "$INSTDIR\Data\ADarkRoomSettings\file__0.localstorage-journal" "$INSTDIR\Data\ADarkRoomSettings\chrome-extension_iaaibobcfjaegfehbgdhhahebcfcnmdb_0.localstorage-journal"
	${EndIf}
!macroend