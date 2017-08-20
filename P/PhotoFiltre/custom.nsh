${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom

	${If} $0 == "fr"
		Delete $EXEDIR\App\PhotoFiltre\Studio*.plg
		Delete $EXEDIR\App\PhotoFiltre\PhotoFiltre7.htm
		CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-fr\PhotoFiltre7.htm" "$EXEDIR\App\PhotoFiltre\"
		Delete $EXEDIR\App\PhotoFiltre\PhotoMasque.htm
		CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-fr\PhotoMasque.htm" "$EXEDIR\App\PhotoFiltre\"
	${Else}
		${If} ${FileExists} "$EXEDIR\App\PhotoFiltre\Languages\Studio$0"
			Delete $EXEDIR\App\PhotoFiltre\Studio*.plg
			CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\Studio$0\Studio$0.plg" "$EXEDIR\App\PhotoFiltre\"
			
			;Get main file in specific language or fallback to English
			Delete $EXEDIR\App\PhotoFiltre\PhotoFiltre7.htm
			${If} ${FileExists} "$EXEDIR\App\PhotoFiltre\Languages\help-$0\PhotoFiltre7.htm"
				CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-$0\PhotoFiltre7.htm" "$EXEDIR\App\PhotoFiltre\"
			${Else}
				CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-en\PhotoFiltre7.htm" "$EXEDIR\App\PhotoFiltre\"
			${EndIf}
			
			;Get photo masque file in specific language or fallback to English
			Delete $EXEDIR\App\PhotoFiltre\PhotoMasque.htm
			${If} ${FileExists} "$EXEDIR\App\PhotoFiltre\Languages\help-$0\PhotoMasque.htm"
				CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-$0\PhotoMasque.htm" "$EXEDIR\App\PhotoFiltre\"
			${Else}
				CopyFiles /SILENT "$EXEDIR\App\PhotoFiltre\Languages\help-en\PhotoMasque.htm" "$EXEDIR\App\PhotoFiltre\"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend

${SegmentPre}
	ReadEnvStr $0 PortableApps.comLanguageCode
	ReadEnvStr $1 PAL:_IgnoreLanguage
	${If} $0 == "fr"
	${AndIf} $1 == false
		${SetEnvironmentVariable} PAL:LanguageCustom fr
	${EndIf}	
!macroend