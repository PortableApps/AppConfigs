!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\LCache"
		${If} ${FileExists} "$INSTDIR\Data\config\*.*"
			;Remove old custom launcher settings and keep current
			RMDir /r "$INSTDIR\Data\settings\LCache"
			RMDir /r "$INSTDIR\Data\settings\Levels"
			RMDir /r "$INSTDIR\Data\settings\Replays"
			Delete "$INSTDIR\Data\settings\xmoto.log"
			Delete "$INSTDIR\Data\settings\config.dat"
			Delete "$INSTDIR\Data\settings\xm.db"
		${Else}
			;Upgrade from old custom launcher
			CreateDirectory "$INSTDIR\Data\config"
			Rename "$INSTDIR\Data\settings\LCache" "$INSTDIR\Data\config\LCache"
			Rename "$INSTDIR\Data\settings\Levels" "$INSTDIR\Data\config\Levels"
			Rename "$INSTDIR\Data\settings\Replays" "$INSTDIR\Data\config\Replays"
			Rename "$INSTDIR\Data\settings\xmoto.log" "$INSTDIR\Data\config\xmoto.log"
			Rename "$INSTDIR\Data\settings\config.dat" "$INSTDIR\Data\config\config.dat"
			Rename "$INSTDIR\Data\settings\xm.db" "$INSTDIR\Data\config\xm.db"
		${EndIf}
	${EndIf}
	
	${If} ${FileExists} "$INSTDIR\Data\share\*.*"
		CreateDirectory "$INSTDIR\Data\config"
		Rename "$INSTDIR\Data\share\Levels" "$INSTDIR\Data\config\Levels"
		Rename "$INSTDIR\Data\share\Replays" "$INSTDIR\Data\config\Replays"
		Rename "$INSTDIR\Data\share\xmoto.log" "$INSTDIR\Data\config\xmoto.log"
		Rename "$INSTDIR\Data\share\xm.db" "$INSTDIR\Data\config\xm.db"
		RMDir /r "$INSTDIR\Data\share"
	${EndIf}
!macroend