!macro CustomCodePreInstall
	;Determine version of opera that will be run
	${If} ${FileExists} "$INSTDIR\App\OperaGX\launcher.exe"
		MoreInfo::GetProductVersion "$INSTDIR\App\OperaGX\launcher.exe"
		Pop $0
		${If} ${FileExists} "$INSTDIR\App\OperaGX\$0\resources\custom_partner_content.json"
			Rename "$INSTDIR\App\OperaGX\$0\resources\custom_partner_content.json" "$INSTDIR\Data\custom_partner_content.json"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	;Determine version of opera that will be run
	${If} ${FileExists} "$INSTDIR\App\OperaGX\launcher.exe"
		MoreInfo::GetProductVersion "$INSTDIR\App\OperaGX\launcher.exe"
		Pop $0
		${If} ${FileExists} "$INSTDIR\Data\custom_partner_content.json"
			Rename "$INSTDIR\Data\custom_partner_content.json" "$INSTDIR\App\OperaGX\$0\resources\custom_partner_content.json"
		${EndIf}
	${EndIf}
!macroend