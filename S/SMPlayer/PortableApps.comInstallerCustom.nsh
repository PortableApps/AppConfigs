!macro CustomCodePostInstall

		${If} ${FileExists} "$INSTDIR\Data\settings"

			; upgrade to 0.7.0
			${If} ${FileExists} "$INSTDIR\Data\settings\smplayer.ini"
				Rename "$INSTDIR\Data\settings\fontconfig" "$INSTDIR\Data\fontconfig"
				Rename "$INSTDIR\Data\settings" "$INSTDIR\Data\smplayer"
				CreateDirectory "$INSTDIR\Data\settings"
				Rename "$INSTDIR\Data\smplayer\SMPlayerPortableSettings.ini" "$INSTDIR\Data\settings\SMPlayerPortableSettings.ini"
			${EndIf}

			; upgrade to 0.7.1
			ReadINIStr $0 "$INSTDIR\Data\smplayer\smplayer.ini" "%General" "screenshot_directory"
			${IfNot} $0 == ""
				WriteINIStr "$INSTDIR\Data\smplayer\smplayer.ini" "%General" "screenshot_folder" "$0"
				DeleteINIStr "$INSTDIR\Data\smplayer\smplayer.ini" "%General" "screenshot_directory"
			${EndIf}

			; upgrade to 0.8.0
			${IfNot} ${FileExists} "$INSTDIR\Data\smplayer\smtube.ini"
				${If} ${FileExists} "$INSTDIR\Data\.smplayer\smtube.ini"
					Rename "$INSTDIR\Data\.smplayer\smtube.ini" "$INSTDIR\Data\smplayer\smtube.ini"
					RMDir "$INSTDIR\Data\.smplayer"
				${Else}
					CopyFiles /SILENT "$INSTDIR\App\DefaultData\smplayer\smtube.ini" "$INSTDIR\Data\smplayer"
					ReadINIStr $0 "$INSTDIR\Data\settings\SMPlayerPortableSettings.ini" "SMPlayerPortableSettings" "LastDrive"
					WriteINIStr "$INSTDIR\Data\smplayer\smtube.ini" "%General" "recording_directory" "$0/"
				${EndIf}
			${EndIf}

			; disable check for new version
			DeleteINIStr "$INSTDIR\Data\smplayer\smplayer.ini" "smplayer" "check_for_new_version" ; old
			WriteINIStr "$INSTDIR\Data\smplayer\smplayer.ini" "smplayer" "check_if_upgraded" "false"
			WriteINIStr "$INSTDIR\Data\smplayer\smplayer.ini" "update_checker" "enabled" "false"

		${EndIf}

!macroend
