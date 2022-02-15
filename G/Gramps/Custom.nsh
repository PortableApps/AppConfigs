${SegmentFile}
Var CustomFirstRunDone

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\GrampsPortableSettings.ini" "Post51Run" "Done"
	${If} $0 != true
		ClearErrors
		${GetParent} $EXEDIR $3
		${If} ${FileExists} "$3\GrampsPortableLegacy\*.*"
			MessageBox MB_ICONINFORMATION|MB_OK "Gramps Database Changes$\r$\n$\r$\nVersion 5.0 and later of Gramps may not be able to import data from version 3.x automatically. Your old version was copied to a GrampsPortableLegacy directory alongside your upgraded one. You can open that version and export to Gramps XML format, then create a new family tree in Gramps 5.1 and import your data if you encounter issues."
			StrCpy $CustomFirstRunDone true
		${Else}
			StrCpy $CustomFirstRunDone true
		${EndIf}
	${EndIf}
!macroend

${SegmentPost}
	${If} $CustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\GrampsPortableSettings.ini" "Post51Run" "Done" "true"
	${EndIf}
!macroend