Var ConfigDirectoryExists

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\GFIE\splash-original.jpg"
		Delete "$INSTDIR\Data\GFIE\splash.jpg"
		Rename "$INSTDIR\Data\GFIE\splash-original.jpg" "$INSTDIR\Data\GFIE\splash.jpg"
	${EndIf}
	
	# update the splash screen with the publisher-provided tweaked one.
	${If} ${FileExists} "${INSTDIR\Data\GFIE\splash.jpg"
		Delete "$INSTDIR\Data\GFIE\splash.jpg"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\GFIE\splash.jpg" "$INSTDIR\Data\GFIE"
	${EndIf}

	IfFileExists "$INSTDIR\App\GreenfishIconEditorPro\Config" "" KeepInstalling
		StrCpy $ConfigDirectoryExists "true"
	KeepInstalling:
!macroend

!macro CustomCodePostInstall
	${If} $ConfigDirectoryExists == "true"
	${AndIf} ${FileExists} "$INSTDIR\Data"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\*.*" "$INSTDIR\Data"
		Rename "$INSTDIR\Data\pref.ini" "$INSTDIR\Data\GFIE\pref.ini"
		Rename "$INSTDIR\Data\recent.txt" "$INSTDIR\Data\GFIE\recent.txt"
		Rename "$INSTDIR\Data\toolbhv.ini" "$INSTDIR\Data\GFIE\toolbhv.ini"
		Rename "$INSTDIR\Data\wndpos.ini" "$INSTDIR\Data\GFIE\wndpos.ini"
		Delete "$INSTDIR\Data\*.png"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\GFIE\pref.ini"
		Delete "$INSTDIR\Data\GFIE\*.png"
		Delete "$INSTDIR\Data\GFIE\*.jpg"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\GFIE\*.png" "$INSTDIR\Data\GFIE\"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\GFIE\*.jpg" "$INSTDIR\Data\GFIE\"
	${EndIf}
!macroend