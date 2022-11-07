!macro CustomCodePostInstall
	Delete "$INSTDIR\App\TCPView\tcpview64a.exe"
	Delete "$INSTDIR\App\TCPView\tcpvcon64a.exe"
	
	${If} ${FileExists} "$INSTDIR\Data\settings\TCPView.reg"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\settings\tcpview.ini"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\settings\tcpview.ini" "$INSTDIR\Data\settings"
	${EndIf}
!macroend
