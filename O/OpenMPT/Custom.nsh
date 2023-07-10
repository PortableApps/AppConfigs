${SegmentFile}

${SegmentInit}
	ReadRegStr $0 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
	
	${If} $0 < 10000
		;Windows 7/8/8.1
		StrCpy $Bits 32
	${EndIf}

    ${If} $Bits = 64
        ${If} ${FileExists} "$EXEDIR\App\OpenMPT-Modern\*.*"
			Rename "$EXEDIR\App\OpenMPT" "$EXEDIR\App\OpenMPT-Legacy"
			Rename "$EXEDIR\App\OpenMPT-Modern" "$EXEDIR\App\OpenMPT"
			Rename "$EXEDIR\App\OpenMPT-Legacy\ExampleSongs" "$EXEDIR\App\OpenMPT\ExampleSongs"
			Rename "$EXEDIR\App\OpenMPT-Legacy\extraKeymaps" "$EXEDIR\App\OpenMPT\extraKeymaps"
			Rename "$EXEDIR\App\OpenMPT-Legacy\Licenses" "$EXEDIR\App\OpenMPT\Licenses"
			Rename "$EXEDIR\App\OpenMPT-Legacy\ReleaseNotesImages" "$EXEDIR\App\OpenMPT\ReleaseNotesImages"
			Rename "$EXEDIR\App\OpenMPT-Legacy\OpenMPT Manual.chm" "$EXEDIR\App\OpenMPT\OpenMPT Manual.chm"
			Rename "$EXEDIR\App\OpenMPT-Legacy\openmpt-wine-support.zip" "$EXEDIR\App\OpenMPT\openmpt-wine-support.zip"
			
			Rename "$EXEDIR\App\OpenMPT-Legacy\Components" "$EXEDIR\App\OpenMPT\Components"
			Rename "$EXEDIR\App\OpenMPT-Legacy\tunings" "$EXEDIR\App\OpenMPT\tunings"
			Rename "$EXEDIR\App\OpenMPT-Legacy\mptrack.ini" "$EXEDIR\App\OpenMPT\mptrack.ini"
			Rename "$EXEDIR\App\OpenMPT-Legacy\Keybindings.mkb" "$EXEDIR\App\OpenMPT\Keybindings.mkb"
			Rename "$EXEDIR\App\OpenMPT-Legacy\plugin.cache" "$EXEDIR\App\OpenMPT\plugin.cache"
			Rename "$EXEDIR\App\OpenMPT-Legacy\SongSettings.ini" "$EXEDIR\App\OpenMPT\SongSettings.ini"
		${EndIf}
	${Else}
        ${If} ${FileExists} "$EXEDIR\App\OpenMPT-Legacy\*.*"
			Rename "$EXEDIR\App\OpenMPT" "$EXEDIR\App\OpenMPT-Modern"
			Rename "$EXEDIR\App\OpenMPT-Legacy" "$EXEDIR\App\OpenMPT"
			Rename "$EXEDIR\App\OpenMPT-Modern\ExampleSongs" "$EXEDIR\App\OpenMPT\ExampleSongs"
			Rename "$EXEDIR\App\OpenMPT-Modern\extraKeymaps" "$EXEDIR\App\OpenMPT\extraKeymaps"
			Rename "$EXEDIR\App\OpenMPT-Modern\Licenses" "$EXEDIR\App\OpenMPT\Licenses"
			Rename "$EXEDIR\App\OpenMPT-Modern\ReleaseNotesImages" "$EXEDIR\App\OpenMPT\ReleaseNotesImages"
			Rename "$EXEDIR\App\OpenMPT-Modern\OpenMPT Manual.chm" "$EXEDIR\App\OpenMPT\OpenMPT Manual.chm"
			Rename "$EXEDIR\App\OpenMPT-Modern\openmpt-wine-support.zip" "$EXEDIR\App\OpenMPT\openmpt-wine-support.zip"
			
			Rename "$EXEDIR\App\OpenMPT-Modern\Components" "$EXEDIR\App\OpenMPT\Components"
			Rename "$EXEDIR\App\OpenMPT-Modern\tunings" "$EXEDIR\App\OpenMPT\tunings"
			Rename "$EXEDIR\App\OpenMPT-Modern\mptrack.ini" "$EXEDIR\App\OpenMPT\mptrack.ini"
			Rename "$EXEDIR\App\OpenMPT-Modern\Keybindings.mkb" "$EXEDIR\App\OpenMPT\Keybindings.mkb"
			Rename "$EXEDIR\App\OpenMPT-Modern\plugin.cache" "$EXEDIR\App\OpenMPT\plugin.cache"
			Rename "$EXEDIR\App\OpenMPT-Modern\SongSettings.ini" "$EXEDIR\App\OpenMPT\SongSettings.ini"
		${EndIf}        
	${EndIf}
!macroend
