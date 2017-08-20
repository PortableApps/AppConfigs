# When using a repo build, App\uTorrent can be missing
!macro CustomCodePreInstall
	${IfNot} ${FileExists} $INSTDIR\App\uTorrent\*.*
		CreateDirectory $INSTDIR\App\uTorrent
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} ${FileExists} $INSTDIR\App\uTorrent\uTorrent_Downloaded.exe
		Delete $INSTDIR\App\uTorrent\uTorrent.exe
		Rename $INSTDIR\App\uTorrent\uTorrent_Downloaded.exe $INSTDIR\App\uTorrent\uTorrent.exe
	${EndIf}
!macroend
