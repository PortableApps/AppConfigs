!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\App\VirtualDub\plugins\AC364.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\AC364.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\AC364.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\FLIC64.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\FLIC64.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\FLV64.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\FLV64.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\Matroska64.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\Matroska64.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\MPEG264.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\MPEG264.vdplugin"
		Rename "$INSTDIR\App\VirtualDub\plugins\WMV64.vdplugin" "$INSTDIR\App\VirtualDub64\plugins\WMV64.vdplugin"	
	${EndIf}
!macroend
