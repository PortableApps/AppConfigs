${SegmentFile}

${SegmentInit}
	ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $0 < 10000
		;Windows 7/8/8.1
		StrCpy $Bits 32
	${EndIf}
	
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\StellariumModern"
			Rename "$EXEDIR\App\Stellarium" "$EXEDIR\App\StellariumLegacy"
			Rename "$EXEDIR\App\StellariumModern" "$EXEDIR\App\Stellarium"
			Rename "$EXEDIR\App\StellariumLegacy\atmosphere" "$EXEDIR\App\Stellarium\atmosphere"
			Rename "$EXEDIR\App\StellariumLegacy\data" "$EXEDIR\App\Stellarium\data"
			Rename "$EXEDIR\App\StellariumLegacy\guide" "$EXEDIR\App\Stellarium\guide"
			Rename "$EXEDIR\App\StellariumLegacy\landscapes" "$EXEDIR\App\Stellarium\landscapes"
			Rename "$EXEDIR\App\StellariumLegacy\models" "$EXEDIR\App\Stellarium\models"
			Rename "$EXEDIR\App\StellariumLegacy\nebulae" "$EXEDIR\App\Stellarium\nebulae"
			Rename "$EXEDIR\App\StellariumLegacy\scenery3d" "$EXEDIR\App\Stellarium\scenery3d"
			Rename "$EXEDIR\App\StellariumLegacy\scripts" "$EXEDIR\App\Stellarium\scripts"
			Rename "$EXEDIR\App\StellariumLegacy\skycultures" "$EXEDIR\App\Stellarium\skycultures"
			Rename "$EXEDIR\App\StellariumLegacy\stars" "$EXEDIR\App\Stellarium\stars"
			Rename "$EXEDIR\App\StellariumLegacy\textures" "$EXEDIR\App\Stellarium\textures"
			Rename "$EXEDIR\App\StellariumLegacy\webroot" "$EXEDIR\App\Stellarium\webroot"
		${EndIf}
	${Else}
        ${If} ${FileExists} "$EXEDIR\App\StellariumLegacy"
			Rename "$EXEDIR\App\Stellarium" "$EXEDIR\App\StellariumModern"
			Rename "$EXEDIR\App\StellariumLegacy" "$EXEDIR\App\Stellarium"
			Rename "$EXEDIR\App\StellariumModern\atmosphere" "$EXEDIR\App\Stellarium\atmosphere"
			Rename "$EXEDIR\App\StellariumModern\data" "$EXEDIR\App\Stellarium\data"
			Rename "$EXEDIR\App\StellariumModern\guide" "$EXEDIR\App\Stellarium\guide"
			Rename "$EXEDIR\App\StellariumModern\landscapes" "$EXEDIR\App\Stellarium\landscapes"
			Rename "$EXEDIR\App\StellariumModern\models" "$EXEDIR\App\Stellarium\models"
			Rename "$EXEDIR\App\StellariumModern\nebulae" "$EXEDIR\App\Stellarium\nebulae"
			Rename "$EXEDIR\App\StellariumModern\scenery3d" "$EXEDIR\App\Stellarium\scenery3d"
			Rename "$EXEDIR\App\StellariumModern\scripts" "$EXEDIR\App\Stellarium\scripts"
			Rename "$EXEDIR\App\StellariumModern\skycultures" "$EXEDIR\App\Stellarium\skycultures"
			Rename "$EXEDIR\App\StellariumModern\stars" "$EXEDIR\App\Stellarium\stars"
			Rename "$EXEDIR\App\StellariumModern\textures" "$EXEDIR\App\Stellarium\textures"
			Rename "$EXEDIR\App\StellariumModern\webroot" "$EXEDIR\App\Stellarium\webroot"
		${EndIf}
	${EndIf}
!macroend