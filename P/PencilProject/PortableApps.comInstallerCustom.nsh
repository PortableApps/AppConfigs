!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\Data\Pencil\*.*"
	${AndIfNot} ${FileExists} "$INSTDIR\Data\PencilUserProfile\*.*"
		CreateDirectory "$INSTDIR\Data\PencilUserProfile"
		CopyFiles /SILENT "$INSTDIR\App\DefaultData\PencilUserProfile\*.*" "$INSTDIR\Data\PencilUserProfile"
	${EndIf}
!macroend