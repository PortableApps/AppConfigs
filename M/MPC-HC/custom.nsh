${SegmentFile}

!define PF_XMMI64_INSTRUCTIONS_AVAILABLE 10

${SegmentInit}
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0

	${If} $0 == 0
		;SSE2 unavailable
		MessageBox MB_ICONEXCLAMATION|MB_OK "This computer has an older CPU that lacks SSE2 instruction set support. Media Player Classic - Home Cinema 1.7.13 and later can not run on this computer."
		Abort
	${EndIf}

	ExpandEnvStrings $1 "%PortableApps.comDocuments%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		${GetParent} $EXEDIR $3
		${GetParent} $3 $1
		${If} $1 == "" ;Be sure we didn't just GetParent on Root
			StrCpy $1 $3
		${EndIf}
		${If} ${FileExists} "$1\Documents\*.*"
			StrCpy $2 "$1\Documents"
		${Else}
			${GetRoot} $EXEDIR $1
			${If} ${FileExists} "$1\Documents\*.*"
				StrCpy $2 "$1\Documents"
			${Else}
				StrCpy $2 "$1"
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comDocuments", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comVideos%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Videos\*.*"
			StrCpy $2 "$1\Videos"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Videos\*.*"
				StrCpy $2 "$1\Videos"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Videos\*.*"
					StrCpy $2 "$1\Videos"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comVideos", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comPictures%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Pictures\*.*"
			StrCpy $2 "$1\Pictures"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Pictures\*.*"
				StrCpy $2 "$1\Pictures"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Pictures\*.*"
					StrCpy $2 "$1\Pictures"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comPictures", "$2").r0'
	${EndIf}
	
	ExpandEnvStrings $1 "%PortableApps.comMusic%"
	${If} $1 == ""
	${OrIfNot} ${FileExists} "$1\*.*"
		ExpandEnvStrings $1 "%PortableApps.comDocuments%"
		${If} ${FileExists} "$1\Music\*.*"
			StrCpy $2 "$1\Music"
		${Else}
			${GetParent} $EXEDIR $3
			${GetParent} $3 $1
			${If} $1 == "" ;Be sure we didn't just GetParent on Root
				StrCpy $1 $3
			${EndIf}
			${If} ${FileExists} "$1\Music\*.*"
				StrCpy $2 "$1\Music"
			${Else}
				${GetRoot} $EXEDIR $1
				${If} ${FileExists} "$1\Music\*.*"
					StrCpy $2 "$1\Music"
				${Else}
					StrCpy $2 "$1"
				${EndIf}
			${EndIf}
		${EndIf}
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PortableApps.comMusic", "$2").r0'
	${EndIf}
!macroend

${SegmentPre}
	; PAL:LanguageCustom is in LCID format, the associated language files are
	; in glibc format. Run custom "CheckIfExists" with the following.
	;
	; Add LCID for these languages when available & remove commenting on them:
	; Esperanto, Kurdish, Sundanese,Valencian
	;
	; Add individual handling for these languages when suported by the app
	; (They currently are handled as another variant of that language):
	; Portuguese, Serbian (Latin), Spanish (Spain AKA Traditional)
	;
	ReadEnvStr $0 PAL:LanguageCustom
	${If} $0 == 1078 ; Afrikaans
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.af.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1052 ; Albanian
	${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sq.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1025 ; Arabic
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ar.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1067 ; Armenian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.hy.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1069 ; Basque
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.eu.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}	
	${ElseIf} $0 == 1059 ; Belarusian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.be.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1093 ; Bengali
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.bn.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 5146 ; Bosnian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.bs_BA.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1150 ; Breton
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ko.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1026 ; Bulgarian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.bg.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish	
		${EndIf}
	${ElseIf} $0 == 1027 ; Catalan
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ca.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2052 ; Chinese (Simplified)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.zh_CN.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1028 ; Chinese (Traditional)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.zh_TW.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1033 ; Cibemba
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.bem.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1050 ; Croatian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.hr.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1029 ; Czech
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.cs.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1030 ; Danish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.da.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1043 ; Dutch
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.nl.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1538 ; Efik
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.efi.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2057 ; English (Great Britain)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.en_GB.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	;${ElseIf} $0 == ? ; Esperanto
	;	${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.eo.dll"
	;		Goto RetainLanguage
	;	${Else}
	;		Goto SetToEnglish
	;	${EndIf}
	${ElseIf} $0 == 1061 ; Estonian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.et.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1065 ; Farsi
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.fa.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1124 ; Filipino
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.tl.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1035 ; Finnish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.fi.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1036 ; French
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.fr.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1110 ; Galician
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.gl.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1079 ; Georgian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ka.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1031 ; German
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.de.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1032 ; Greek
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.el.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1037 ; Hebrew
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.he.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1038 ; Hungarian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.hu.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1039 ; Icelandic
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.is.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1136 ; Igbo
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ig.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1057 ; Indonesian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.id.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2108 ; Irish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ga.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1040 ; Italian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.it.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1041 ; Japanese
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ja.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1107 ; Khmer
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.km.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1042 ; Korean
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ko.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	;${ElseIf} $0 == ? ; Kurdish
	;	${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ku.dll"
	;		Goto RetainLanguage
	;	${Else}
	;		Goto SetToEnglish
	;	${EndIf}
	${ElseIf} $0 == 1062 ; Latvian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.en_GB.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1063 ; Lithuanian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.lt.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1033 ; Luxembourgish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.lb.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1071 ; Macedonian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.mk.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1536 ; Malagasy
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.mg.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1086 ; Malay
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ms_MY.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1104 ; Mongolian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.mn.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1044 ; Norwegian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.nb.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2068 ; Norwegian Nynorsk
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.nn.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1123 ; Pashto
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ps.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1045 ; Polish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.pl.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2070 ; Portuguese
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.pt.dll"
			Goto RetainLanguage
		${ElseIf} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.pt_BR.dll"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "1046").r0'
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1046 ; Portuguese (Brazil)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.pt_BR.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1094 ; Punjabi
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.pa.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1048 ; Romanian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ro.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1049 ; Russian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ru.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 3098 ; Serbian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sr.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 2074 ; Serbian (Latin)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sr.dll"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "3098").r0'
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1051 ; Slovak
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sk.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1060 ; Slovenian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sl.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1034 ; Spanish (Traditional) (Spain)
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.es.dll"
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "3082").r0'
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 3082 ; Spanish International
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.es.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	;${ElseIf} $0 == ? ; Sundanese
	;	${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.su.dll"
	;		Goto RetainLanguage
	;	${Else}
	;		Goto SetToEnglish
	;	${EndIf}
	${ElseIf} $0 == 1089 ; Swahili
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ko.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1053 ; Swedish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.sv.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1092 ; Tatar
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.tt.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1054 ; Thai
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.th_TH.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1055 ; Turkish
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.tr.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1058 ; Ukrainian
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.uk.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1091 ; Uzbek
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.uz.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	;${ElseIf} $0 == ? ; Valencian
	;	${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.ca_ES_valencia.dll"
	;		Goto RetainLanguage
	;	${Else}
	;		Goto SetToEnglish
	;	${EndIf}
	${ElseIf} $0 == 1066 ; Vietnamese
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.vi.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1106 ; Welsh
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.cy.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${ElseIf} $0 == 1130 ; Yoruba
		${If} ${FileExists} "$EXEDIR\App\MPC-HC\Lang\mpcresources.yo.dll"
			Goto RetainLanguage
		${Else}
			Goto SetToEnglish
		${EndIf}
	${Else}
		SetToEnglish:
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("PAL:LanguageCustom", "0").r0'
	${EndIf}
	RetainLanguage:
!macroend