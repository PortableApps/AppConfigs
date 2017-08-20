${SegmentFile}

Var PALCustomPortableAppsParent

!addincludedir "${PACKAGE}\App\AppInfo\Launcher"
!include StrCase.nsh


${Segment.OnInit}
	${GetParent} "$EXEDIR" $0
	${GetParent} $0 $1
	
	${WordReplace} "$0" "$1\" "" "+" $2
	
	${StrCase} $3 $2 "L"
	
	${If} $3 == "portableapps"
		StrCpy $PALCustomPortableAppsParent true
	${EndIf}
!macroend

${SegmentPrePrimary}
	${If} $PALCustomPortableAppsParent != true
		CreateDirectory "$EXEDIR\App\jarte\Data"
		Rename "$EXEDIR\Data\Backgrounds" "$EXEDIR\App\jarte\Data\Backgrounds"
		Rename "$EXEDIR\Data\Converters" "$EXEDIR\App\jarte\Data\Converters"
		Rename "$EXEDIR\Data\Custom Spell" "$EXEDIR\App\jarte\Data\Custom Spell"
		Rename "$EXEDIR\Data\Document Backups" "$EXEDIR\App\jarte\Data\Document Backups"
		Rename "$EXEDIR\Data\Templates" "$EXEDIR\App\jarte\Data\Templates"
		Rename "$EXEDIR\Data\Settings.ini" "$EXEDIR\App\jarte\Data\Settings.ini"
	${EndIf}
!macroend

${SegmentPostPrimary}
	${If} $PALCustomPortableAppsParent != true
		Rename "$EXEDIR\App\jarte\Data\Backgrounds" "$EXEDIR\Data\Backgrounds"
		Rename "$EXEDIR\App\jarte\Data\Converters" "$EXEDIR\Data\Converters"
		Rename "$EXEDIR\App\jarte\Data\Custom Spell" "$EXEDIR\Data\Custom Spell"
		Rename "$EXEDIR\App\jarte\Data\Document Backups" "$EXEDIR\Data\Document Backups"
		Rename "$EXEDIR\App\jarte\Data\Templates" "$EXEDIR\Data\Templates"
		Rename "$EXEDIR\App\jarte\Data\Settings.ini" "$EXEDIR\Data\Settings.ini"
	${EndIf}
!macroend