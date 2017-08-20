${SegmentFile}

${SegmentInit}
	Delete "$EXEDIR\App\GnuCash\share\guile\1.8\slibcat"
!macroend

${SegmentPre}
	ExpandEnvStrings $R0 %PAL:LanguageCustom%
	StrLen $R1 $R0
	${If} $R1 == 2
		${StrFilter} $R0 "+" "" "" $R2
		${SetEnvironmentVariable} LANG "$R0_$R2"
	${Else}
		${SetEnvironmentVariable} LANG $R0
	${EndIf}
!macroend