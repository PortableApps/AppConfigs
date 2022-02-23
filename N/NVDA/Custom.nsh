${SegmentFile}

${SegmentPostPrimary}
	ReadINIStr $R0 "$EXEDIR\Data\settings\NVDAPortableSettings.ini" "NVDAPortableSettings" "IgnoreLockedFiles"
	${If} $R0 != "true"
		${If} $Bits == 64
			StrCpy $0 "$EXEDIR\App\NVDA\lib64\2021.3.3"
		${Else}
			StrCpy $0 "$EXEDIR\App\NVDA\lib\2021.3.3"
		${EndIf}
		CopyFiles /SILENT "$0\IAccessible2proxy.dll" "$0\temp\IAccessible2proxy.dll"
		Delete "$0\IAccessible2proxy.dll"
		${IfNot} ${FileExists} "$0\IAccessible2proxy.dll"
			Rename "$0\temp\IAccessible2proxy.dll" "$0\IAccessible2proxy.dll"
			RMDir "$0\temp"
		${Else}
			Delete "$0\temp\IAccessible2proxy.dll"
			RMDir "$0\temp"
			${If} $R0 == "false"
				Goto CustomCloseApps
			${EndIf}
			MessageBox MB_YESNO|MB_ICONQUESTION "Some of NVDA's files are still in use by other processes. Would you like to ignore this issue now and in the future (if you only use NVDA on a single machine on an internal drive, for instance)?" IDYES CustomIgnoreLockedFiles IDNO CustomCloseApps
			
			CustomIgnoreLockedFiles:
				WriteINIStr "$EXEDIR\Data\settings\NVDAPortableSettings.ini" "NVDAPortableSettings" "IgnoreLockedFiles" "true"
				Goto CustomEnd
				
			CustomCloseApps:
				WriteINIStr "$EXEDIR\Data\settings\NVDAPortableSettings.ini" "NVDAPortableSettings" "IgnoreLockedFiles" "false"
				MessageBox MB_OK|MB_ICONINFORMATION "Some of NVDA's files are still in use by other processes. Please try closing any apps you used while NVDA Portable was open, particularly Firefox and Thunderbird. Click OK once that is done."
				
				CopyFiles /SILENT "$0\IAccessible2proxy.dll" "$0\temp\IAccessible2proxy.dll"
				Delete "$0\IAccessible2proxy.dll"
				${IfNot} ${FileExists} "$0\IAccessible2proxy.dll"
					Rename "$0\temp\IAccessible2proxy.dll" "$0\IAccessible2proxy.dll"
					RMDir "$0\temp"
					MessageBox MB_OK|MB_ICONINFORMATION "The files have been unlocked and NVDA Portable can now fully close."
					Goto CustomEnd
				${Else}
					Delete "$0\temp\IAccessible2proxy.dll"
					RMDir "$0\temp"
					MessageBox MB_YESNO|MB_ICONQUESTION "The files are still locked, would you like to try restarting Windows Explorer to see if that helps unlock them? Note that this will close all open Windows Explorer windows and may cause some system tray icons to not show until you restart." IDYES CustomRestartExplorer IDNO CustomStillLocked
					
					CustomRestartExplorer:
						nsExec::Exec "$EXEDIR\App\bin\CloseExplorer.bat"
						Pop $R2
						Exec "$WINDIR\explorer.exe"
						CopyFiles /SILENT "$0\IAccessible2proxy.dll" "$0\temp\IAccessible2proxy.dll"
						Delete "$0\IAccessible2proxy.dll"
						${IfNot} ${FileExists} "$0\IAccessible2proxy.dll"
							Rename "$0\temp\IAccessible2proxy.dll" "$0\IAccessible2proxy.dll"
							RMDir "$0\temp"
							MessageBox MB_OK|MB_ICONINFORMATION "The files have been unlocked and NVDA Portable can now fully close."
							Goto CustomEnd
						${Else}
							Delete "$0\temp\IAccessible2proxy.dll"
							RMDir "$0\temp"
							Goto CustomStillLocked
						${EndIf}
					
				CustomStillLocked:
					MessageBox MB_OK|MB_ICONEXCLAMATION "The files are still locked. NVDA Portable won't be able to be moved, deleted, or ejected until you sign out of Windows and back in again."
			${EndIf}
		${EndIf}
	${EndIf}
	CustomEnd:
!macroend