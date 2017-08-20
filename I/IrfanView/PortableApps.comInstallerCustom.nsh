!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\IrfanView\i_view32.ini"
		${IfNot} ${FileExists} "$INSTDIR\Data\IrfanView\license.ini"
			ReadINIStr $0 "$INSTDIR\App\IrfanView\i_view32.ini" "Registration" "Name"
			${If} $0 != ""
				Rename "$INSTDIR\App\IrfanView\i_view32.ini" "$INSTDIR\Data\IrfanView\license.ini"
				DeleteINISec "$EXEDIR\Data\IrfanView\license.ini" "Others"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\IrfanView\i_view32.ini"
		${IfNot} ${FileExists} "$INSTDIR\Data\IrfanView\license.ini"
			CopyFiles /SILENT "$INSTDIR\App\DefaultData\IrfanView\license.ini" "$INSTDIR\Data\IrfanView"
		${EndIf}
	${EndIf}
!macroend