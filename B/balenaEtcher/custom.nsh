${SegmentFile}

${SegmentPrePrimary}
	${If} $Bits = 64
		Rename "$EXEDIR\App\balenaEtcher\locales" "$EXEDIR\App\balenaEtcher64\locales"
		;Rename "$EXEDIR\App\balenaEtcher\resources\app" "$EXEDIR\App\balenaEtcher64\resources\app"
		Rename "$EXEDIR\App\balenaEtcher\icudtl.dat" "$EXEDIR\App\balenaEtcher64\icudtl.dat"
		Rename "$EXEDIR\App\balenaEtcher\resources.pak" "$EXEDIR\App\balenaEtcher64\resources.pak"
	${Else}
		Rename "$EXEDIR\App\balenaEtcher64\locales" "$EXEDIR\App\balenaEtcher\locales"
		;Rename "$EXEDIR\App\balenaEtcher64\resources\app" "$EXEDIR\App\balenaEtcher\resources\app"
		Rename "$EXEDIR\App\balenaEtcher64\icudtl.dat" "$EXEDIR\App\balenaEtcher\icudtl.dat"
		Rename "$EXEDIR\App\balenaEtcher64\resources.pak" "$EXEDIR\App\balenaEtcher\resources.pak"
	${EndIf}
!macroend