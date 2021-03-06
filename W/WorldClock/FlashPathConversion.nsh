;Copyright 2013 John T. Haller and PortableApps.com
;Licensed under the GPL

;Flash requires oddball character encoding for everything above ASCII 127
;For right now, everything outside of ASCII will fail

;Usage: ${ConvertPathToFlash} INPUT OUTPUT
;Usage: ${ConvertPathFromFlash} INPUT OUTPUT

Function ConvertPathToFlash
	;Start with a clean slate
	ClearErrors
	
	;Get our parameters
	Exch $0 ;INPUT_VALUE
	
	;ASCII 128-191
	${WordReplace} "$0" "€" "E#28#2A#C" "+" $0
	${WordReplace} "$0" "‚" "E#28#09#A" "+" $0
	${WordReplace} "$0" "ƒ" "C#69#2" "+" $0
	${WordReplace} "$0" "„" "E#28#09#E" "+" $0
	${WordReplace} "$0" "…" "E#28#0A#6" "+" $0
	${WordReplace} "$0" "†" "E#28#0A#0" "+" $0
	${WordReplace} "$0" "‡" "E#28#0A#1" "+" $0
	${WordReplace} "$0" "ˆ" "C#B8#6" "+" $0
	${WordReplace} "$0" "‰" "E#28#0B#0" "+" $0
	${WordReplace} "$0" "Š" "C#5A#0" "+" $0
	${WordReplace} "$0" "‹" "E#28#0B#9" "+" $0
	${WordReplace} "$0" "Œ" "C#59#2" "+" $0
	${WordReplace} "$0" "Ž" "C#5B#D" "+" $0
	${WordReplace} "$0" "‘" "E#28#09#8" "+" $0
	${WordReplace} "$0" "’" "E#28#09#9" "+" $0
	${WordReplace} "$0" "“" "E#28#09#C" "+" $0
	${WordReplace} "$0" "”" "E#28#09#D" "+" $0
	${WordReplace} "$0" "•" "E#28#0A#2" "+" $0
	${WordReplace} "$0" "–" "E#28#09#3" "+" $0
	${WordReplace} "$0" "—" "E#28#09#4" "+" $0
	${WordReplace} "$0" "˜" "C#B9#C" "+" $0
	${WordReplace} "$0" "™" "E#28#4A#2" "+" $0
	${WordReplace} "$0" "š" "C#5A#1" "+" $0
	${WordReplace} "$0" "›" "E#28#0B#A" "+" $0
	${WordReplace} "$0" "œ" "C#59#3" "+" $0
	${WordReplace} "$0" "ž" "C#5B#E" "+" $0
	${WordReplace} "$0" "Ÿ" "C#5B#8" "+" $0
	${WordReplace} "$0" "¡" "C#2A#1" "+" $0
	${WordReplace} "$0" "¢" "C#2A#2" "+" $0
	${WordReplace} "$0" "£" "C#2A#3" "+" $0
	${WordReplace} "$0" "¤" "C#2A#4" "+" $0
	${WordReplace} "$0" "¥" "C#2A#5" "+" $0
	${WordReplace} "$0" "¦" "C#2A#6" "+" $0
	${WordReplace} "$0" "§" "C#2A#7" "+" $0
	${WordReplace} "$0" "¨" "C#2A#8" "+" $0
	${WordReplace} "$0" "©" "C#2A#9" "+" $0
	${WordReplace} "$0" "ª" "C#2A#A" "+" $0
	${WordReplace} "$0" "«" "C#2A#B" "+" $0
	${WordReplace} "$0" "¬" "C#2A#C" "+" $0
	${WordReplace} "$0" "®" "C#2A#E" "+" $0
	${WordReplace} "$0" "¯" "C#2A#F" "+" $0
	${WordReplace} "$0" "°" "C#2B#0" "+" $0
	${WordReplace} "$0" "±" "C#2B#1" "+" $0
	${WordReplace} "$0" "²" "C#2B#2" "+" $0
	${WordReplace} "$0" "³" "C#2B#3" "+" $0
	${WordReplace} "$0" "´" "C#2B#4" "+" $0
	${WordReplace} "$0" "µ" "C#2B#5" "+" $0
	${WordReplace} "$0" "¶" "C#2B#6" "+" $0
	${WordReplace} "$0" "·" "C#2B#7" "+" $0
	${WordReplace} "$0" "¸" "C#2B#8" "+" $0
	${WordReplace} "$0" "¹" "C#2B#9" "+" $0
	${WordReplace} "$0" "º" "C#2B#A" "+" $0
	${WordReplace} "$0" "»" "C#2B#B" "+" $0
	${WordReplace} "$0" "¼" "C#2B#C" "+" $0
	${WordReplace} "$0" "½" "C#2B#D" "+" $0
	${WordReplace} "$0" "¾" "C#2B#E" "+" $0
	${WordReplace} "$0" "¿" "C#2B#F" "+" $0	
	
	;ASCII 192-223
	${WordReplace} "$0" "À" "C#38#0" "+" $0
	${WordReplace} "$0" "Á" "C#38#1" "+" $0
	${WordReplace} "$0" "Â" "C#38#2" "+" $0
	${WordReplace} "$0" "Ã" "C#38#3" "+" $0
	${WordReplace} "$0" "Ä" "C#38#4" "+" $0
	${WordReplace} "$0" "Å" "C#38#5" "+" $0
	${WordReplace} "$0" "Æ" "C#38#6" "+" $0
	${WordReplace} "$0" "Ç" "C#38#7" "+" $0
	${WordReplace} "$0" "È" "C#38#8" "+" $0
	${WordReplace} "$0" "É" "C#38#9" "+" $0
	${WordReplace} "$0" "Ê" "C#38#A" "+" $0
	${WordReplace} "$0" "Ë" "C#38#B" "+" $0
	${WordReplace} "$0" "Ì" "C#38#C" "+" $0
	${WordReplace} "$0" "Í" "C#38#D" "+" $0
	${WordReplace} "$0" "Î" "C#38#E" "+" $0
	${WordReplace} "$0" "Ï" "C#38#F" "+" $0
	${WordReplace} "$0" "Ð" "C#39#0" "+" $0
	${WordReplace} "$0" "Ñ" "C#39#1" "+" $0
	${WordReplace} "$0" "Ò" "C#39#2" "+" $0
	${WordReplace} "$0" "Ó" "C#39#3" "+" $0
	${WordReplace} "$0" "Ô" "C#39#4" "+" $0
	${WordReplace} "$0" "Õ" "C#39#5" "+" $0
	${WordReplace} "$0" "Ö" "C#39#6" "+" $0
	${WordReplace} "$0" "×" "C#39#7" "+" $0
	${WordReplace} "$0" "Ø" "C#39#8" "+" $0
	${WordReplace} "$0" "Ù" "C#39#9" "+" $0
	${WordReplace} "$0" "Ú" "C#39#A" "+" $0
	${WordReplace} "$0" "Û" "C#39#B" "+" $0
	${WordReplace} "$0" "Ü" "C#39#C" "+" $0
	${WordReplace} "$0" "Ý" "C#39#D" "+" $0
	${WordReplace} "$0" "Þ" "C#39#E" "+" $0
	${WordReplace} "$0" "ß" "C#39#F" "+" $0
	
	;ASCII 224-255
	${WordReplace} "$0" "à" "C#3A#0" "+" $0
	${WordReplace} "$0" "á" "C#3A#1" "+" $0
	${WordReplace} "$0" "â" "C#3A#2" "+" $0
	${WordReplace} "$0" "ã" "C#3A#3" "+" $0
	${WordReplace} "$0" "ä" "C#3A#4" "+" $0
	${WordReplace} "$0" "å" "C#3A#5" "+" $0
	${WordReplace} "$0" "æ" "C#3A#6" "+" $0
	${WordReplace} "$0" "ç" "C#3A#7" "+" $0
	${WordReplace} "$0" "è" "C#3A#8" "+" $0
	${WordReplace} "$0" "é" "C#3A#9" "+" $0
	${WordReplace} "$0" "ê" "C#3A#A" "+" $0
	${WordReplace} "$0" "ë" "C#3A#B" "+" $0
	${WordReplace} "$0" "ì" "C#3A#C" "+" $0
	${WordReplace} "$0" "í" "C#3A#D" "+" $0
	${WordReplace} "$0" "î" "C#3A#E" "+" $0
	${WordReplace} "$0" "ï" "C#3A#F" "+" $0
	${WordReplace} "$0" "ð" "C#3B#0" "+" $0
	${WordReplace} "$0" "ñ" "C#3B#1" "+" $0
	${WordReplace} "$0" "ò" "C#3B#2" "+" $0
	${WordReplace} "$0" "ó" "C#3B#3" "+" $0
	${WordReplace} "$0" "ô" "C#3B#4" "+" $0
	${WordReplace} "$0" "õ" "C#3B#5" "+" $0
	${WordReplace} "$0" "ö" "C#3B#6" "+" $0
	${WordReplace} "$0" "÷" "C#3B#7" "+" $0
	${WordReplace} "$0" "ø" "C#3B#8" "+" $0
	${WordReplace} "$0" "ù" "C#3B#9" "+" $0
	${WordReplace} "$0" "ú" "C#3B#A" "+" $0
	${WordReplace} "$0" "û" "C#3B#B" "+" $0
	${WordReplace} "$0" "ü" "C#3B#C" "+" $0
	${WordReplace} "$0" "ý" "C#3B#D" "+" $0
	${WordReplace} "$0" "þ" "C#3B#E" "+" $0
	${WordReplace} "$0" "ÿ" "C#3B#F" "+" $0
		
	;Reset the last variable and leave our result on the stack
	Exch $0 ;OUTPUT_VALUE
FunctionEnd

!macro ConvertPathToFlash INPUT_VALUE OUTPUT_VALUE
  Push `${INPUT_VALUE}`
  Call ConvertPathToFlash
  Pop `${OUTPUT_VALUE}`
!macroend

!define ConvertPathToFlash '!insertmacro "ConvertPathToFlash"'


Function ConvertPathFromFlash
	;Start with a clean slate
	ClearErrors
	
	;Get our parameters
	Exch $0 ;INPUT_VALUE
	
	;ASCII 128-191
	${WordReplace} "$0" "E#28#2A#C" "€" "+" $0
	${WordReplace} "$0" "E#28#09#A" "‚" "+" $0
	${WordReplace} "$0" "C#69#2" "ƒ" "+" $0
	${WordReplace} "$0" "E#28#09#E" "„" "+" $0
	${WordReplace} "$0" "E#28#0A#6" "…" "+" $0
	${WordReplace} "$0" "E#28#0A#0" "†" "+" $0
	${WordReplace} "$0" "E#28#0A#1" "‡" "+" $0
	${WordReplace} "$0" "C#B8#6" "ˆ" "+" $0
	${WordReplace} "$0" "E#28#0B#0" "‰" "+" $0
	${WordReplace} "$0" "C#5A#0" "Š" "+" $0
	${WordReplace} "$0" "E#28#0B#9" "‹" "+" $0
	${WordReplace} "$0" "C#59#2" "Œ" "+" $0
	${WordReplace} "$0" "C#5B#D" "Ž" "+" $0
	${WordReplace} "$0" "E#28#09#8" "‘" "+" $0
	${WordReplace} "$0" "E#28#09#9" "’" "+" $0
	${WordReplace} "$0" "E#28#09#C" "“" "+" $0
	${WordReplace} "$0" "E#28#09#D" "”" "+" $0
	${WordReplace} "$0" "E#28#0A#2" "•" "+" $0
	${WordReplace} "$0" "E#28#09#3" "–" "+" $0
	${WordReplace} "$0" "E#28#09#4" "—" "+" $0
	${WordReplace} "$0" "C#B9#C" "˜" "+" $0
	${WordReplace} "$0" "E#28#4A#2" "™" "+" $0
	${WordReplace} "$0" "C#5A#1" "š" "+" $0
	${WordReplace} "$0" "E#28#0B#A" "›" "+" $0
	${WordReplace} "$0" "C#59#3" "œ" "+" $0
	${WordReplace} "$0" "C#5B#E" "ž" "+" $0
	${WordReplace} "$0" "C#5B#8" "Ÿ" "+" $0
	${WordReplace} "$0" "C#2A#1" "¡" "+" $0
	${WordReplace} "$0" "C#2A#2" "¢" "+" $0
	${WordReplace} "$0" "C#2A#3" "£" "+" $0
	${WordReplace} "$0" "C#2A#4" "¤" "+" $0
	${WordReplace} "$0" "C#2A#5" "¥" "+" $0
	${WordReplace} "$0" "C#2A#6" "¦" "+" $0
	${WordReplace} "$0" "C#2A#7" "§" "+" $0
	${WordReplace} "$0" "C#2A#8" "¨" "+" $0
	${WordReplace} "$0" "C#2A#9" "©" "+" $0
	${WordReplace} "$0" "C#2A#A" "ª" "+" $0
	${WordReplace} "$0" "C#2A#B" "«" "+" $0
	${WordReplace} "$0" "C#2A#C" "¬" "+" $0
	${WordReplace} "$0" "C#2A#E" "®" "+" $0
	${WordReplace} "$0" "C#2A#F" "¯" "+" $0
	${WordReplace} "$0" "C#2B#0" "°" "+" $0
	${WordReplace} "$0" "C#2B#1" "±" "+" $0
	${WordReplace} "$0" "C#2B#2" "²" "+" $0
	${WordReplace} "$0" "C#2B#3" "³" "+" $0
	${WordReplace} "$0" "C#2B#4" "´" "+" $0
	${WordReplace} "$0" "C#2B#5" "µ" "+" $0
	${WordReplace} "$0" "C#2B#6" "¶" "+" $0
	${WordReplace} "$0" "C#2B#7" "·" "+" $0
	${WordReplace} "$0" "C#2B#8" "¸" "+" $0
	${WordReplace} "$0" "C#2B#9" "¹" "+" $0
	${WordReplace} "$0" "C#2B#A" "º" "+" $0
	${WordReplace} "$0" "C#2B#B" "»" "+" $0
	${WordReplace} "$0" "C#2B#C" "¼" "+" $0
	${WordReplace} "$0" "C#2B#D" "½" "+" $0
	${WordReplace} "$0" "C#2B#E" "¾" "+" $0
	${WordReplace} "$0" "C#2B#F" "¿" "+" $0	
	
	;ASCII 192-223
	${WordReplace} "$0" "C#38#0" "À" "+" $0
	${WordReplace} "$0" "C#38#1" "Á" "+" $0
	${WordReplace} "$0" "C#38#2" "Â" "+" $0
	${WordReplace} "$0" "C#38#3" "Ã" "+" $0
	${WordReplace} "$0" "C#38#4" "Ä" "+" $0
	${WordReplace} "$0" "C#38#5" "Å" "+" $0
	${WordReplace} "$0" "C#38#6" "Æ" "+" $0
	${WordReplace} "$0" "C#38#7" "Ç" "+" $0
	${WordReplace} "$0" "C#38#8" "È" "+" $0
	${WordReplace} "$0" "C#38#9" "É" "+" $0
	${WordReplace} "$0" "C#38#A" "Ê" "+" $0
	${WordReplace} "$0" "C#38#B" "Ë" "+" $0
	${WordReplace} "$0" "C#38#C" "Ì" "+" $0
	${WordReplace} "$0" "C#38#D" "Í" "+" $0
	${WordReplace} "$0" "C#38#E" "Î" "+" $0
	${WordReplace} "$0" "C#38#F" "Ï" "+" $0
	${WordReplace} "$0" "C#39#0" "Ð" "+" $0
	${WordReplace} "$0" "C#39#1" "Ñ" "+" $0
	${WordReplace} "$0" "C#39#2" "Ò" "+" $0
	${WordReplace} "$0" "C#39#3" "Ó" "+" $0
	${WordReplace} "$0" "C#39#4" "Ô" "+" $0
	${WordReplace} "$0" "C#39#5" "Õ" "+" $0
	${WordReplace} "$0" "C#39#6" "Ö" "+" $0
	${WordReplace} "$0" "C#39#7" "×" "+" $0
	${WordReplace} "$0" "C#39#8" "Ø" "+" $0
	${WordReplace} "$0" "C#39#9" "Ù" "+" $0
	${WordReplace} "$0" "C#39#A" "Ú" "+" $0
	${WordReplace} "$0" "C#39#B" "Û" "+" $0
	${WordReplace} "$0" "C#39#C" "Ü" "+" $0
	${WordReplace} "$0" "C#39#D" "Ý" "+" $0
	${WordReplace} "$0" "C#39#E" "Þ" "+" $0
	${WordReplace} "$0" "C#39#F" "ß" "+" $0
	
	;ASCII 224-255
	${WordReplace} "$0" "C#3A#0" "à" "+" $0
	${WordReplace} "$0" "C#3A#1" "á" "+" $0
	${WordReplace} "$0" "C#3A#2" "â" "+" $0
	${WordReplace} "$0" "C#3A#3" "ã" "+" $0
	${WordReplace} "$0" "C#3A#4" "ä" "+" $0
	${WordReplace} "$0" "C#3A#5" "å" "+" $0
	${WordReplace} "$0" "C#3A#6" "æ" "+" $0
	${WordReplace} "$0" "C#3A#7" "ç" "+" $0
	${WordReplace} "$0" "C#3A#8" "è" "+" $0
	${WordReplace} "$0" "C#3A#9" "é" "+" $0
	${WordReplace} "$0" "C#3A#A" "ê" "+" $0
	${WordReplace} "$0" "C#3A#B" "ë" "+" $0
	${WordReplace} "$0" "C#3A#C" "ì" "+" $0
	${WordReplace} "$0" "C#3A#D" "í" "+" $0
	${WordReplace} "$0" "C#3A#E" "î" "+" $0
	${WordReplace} "$0" "C#3A#F" "ï" "+" $0
	${WordReplace} "$0" "C#3B#0" "ð" "+" $0
	${WordReplace} "$0" "C#3B#1" "ñ" "+" $0
	${WordReplace} "$0" "C#3B#2" "ò" "+" $0
	${WordReplace} "$0" "C#3B#3" "ó" "+" $0
	${WordReplace} "$0" "C#3B#4" "ô" "+" $0
	${WordReplace} "$0" "C#3B#5" "õ" "+" $0
	${WordReplace} "$0" "C#3B#6" "ö" "+" $0
	${WordReplace} "$0" "C#3B#7" "÷" "+" $0
	${WordReplace} "$0" "C#3B#8" "ø" "+" $0
	${WordReplace} "$0" "C#3B#9" "ù" "+" $0
	${WordReplace} "$0" "C#3B#A" "ú" "+" $0
	${WordReplace} "$0" "C#3B#B" "û" "+" $0
	${WordReplace} "$0" "C#3B#C" "ü" "+" $0
	${WordReplace} "$0" "C#3B#D" "ý" "+" $0
	${WordReplace} "$0" "C#3B#E" "þ" "+" $0
	${WordReplace} "$0" "C#3B#F" "ÿ" "+" $0
		
	;Reset the last variable and leave our result on the stack
	Exch $0 ;OUTPUT_VALUE
FunctionEnd

!macro ConvertPathFromFlash INPUT_VALUE OUTPUT_VALUE
  Push `${INPUT_VALUE}`
  Call ConvertPathFromFlash
  Pop `${OUTPUT_VALUE}`
!macroend

!define ConvertPathFromFlash '!insertmacro "ConvertPathFromFlash"'