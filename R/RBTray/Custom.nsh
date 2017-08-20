${SegmentFile}

${SegmentInit}
	${If} ${ProcessExists} RBTray.exe
		MessageBox MB_YESNO|MB_ICONQUESTION "RBTray is already running. Would you like to close RBTray now?$\r$\n$\r$\nHelpful Tip: RBTray has no user interface or icon of its own.  While running, you can minimize most windows to the system tray by right-clicking on the window's minimize button.  To exit RBTray, right-click on one of the minimized application icons in the system tray and select exit.  Or you can run RBTray Portable again and you will be asked if you want to close the running copy." IDNO skipclose
			;Get the handle to the window
			FindWindow $R0 "RBTrayHook" ""
			StrCmp $R0 0 skipclose
				;Send WM_COMMAND IDM_EXIT
				SendMessage $R0 0x111 0x1003 0 /TIMEOUT=15
	
		skipclose:
		Abort
	${EndIf}
!macroend

${SegmentPre}
	ReadINIStr $0 "$EXEDIR\Data\settings\RBTrayPortableSettings.ini" "FirstRun" "Done"
	${If} $0 != true
		ClearErrors
		MessageBox MB_ICONINFORMATION|MB_OK "Welcome to your first run of RBTray Portable!  RBTray has no user interface or icon of its own.  While running, you can minimize most windows to the system tray by right-clicking on the window's minimize button.  To exit RBTray, right-click on one of the minimized application icons in the system tray and select exit.  Or run RBTray Portable again and you will be asked if you want to close the running copy.  Enjoy!"
	${EndIf}
	WriteINIStr "$EXEDIR\Data\settings\RBTrayPortableSettings.ini" "FirstRun" "Done" "true"
!macroend

${SegmentPost}
	WriteINIStr "$EXEDIR\Data\settings\RBTrayPortableSettings.ini" "FirstRun" "Done" "true"
!macroend
