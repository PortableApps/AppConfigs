${SegmentFile}

${SegmentPrePrimary}
	ReadEnvStr $0 PAL:LanguageCustom
	
	${If} $0 == "French"
		${If} ${FileExists} "$EXEDIR\App\Dicom\DictionnaireICOMFrench.exe"
			Rename "$EXEDIR\App\Dicom\DictionnaireICOM.exe" "$EXEDIR\App\Dicom\DictionnaireICOMEnglish.exe"
			Rename "$EXEDIR\App\Dicom\DictionnaireICOMFrench.exe" "$EXEDIR\App\Dicom\DictionnaireICOM.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\settings\DICOMFrench.dic"
			Rename "$EXEDIR\Data\settings\DICOM.dic" "$EXEDIR\Data\settings\DICOMEnglish.dic"
			Rename "$EXEDIR\Data\settings\DICOMFrench.dic" "$EXEDIR\Data\settings\DICOM.dic"
		${EndIf}
	${Else} ;English
		${If} ${FileExists} "$EXEDIR\App\Dicom\DictionnaireICOMEnglish.exe"
			Rename "$EXEDIR\App\Dicom\DictionnaireICOM.exe" "$EXEDIR\App\Dicom\DictionnaireICOMFrench.exe"
			Rename "$EXEDIR\App\Dicom\DictionnaireICOMEnglish.exe" "$EXEDIR\App\Dicom\DictionnaireICOM.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\Data\settings\DICOMEnglish.dic"
			Rename "$EXEDIR\Data\settings\DICOM.dic" "$EXEDIR\Data\settings\DICOMFrench.dic"
			Rename "$EXEDIR\Data\settings\DICOMEnglish.dic" "$EXEDIR\Data\settings\DICOM.dic"
		${EndIf}
	${EndIf}
!macroend