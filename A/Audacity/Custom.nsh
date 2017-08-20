!define PF_XMMI64_INSTRUCTIONS_AVAILABLE 10

${SegmentFile}

${SegmentInit}
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0

	${If} $0 != 0
		;SSE2 is available
		Goto ContinueExection
	${Else}
		;SSE2 unavailable, Abort running
		Abort "Audacity Portable requires the CPU to support the SSE2 instruction set which should be available on any Intel hardware produced after 2001 and any AMD hardware produced after 2003. To check what SSE levels your CPU supports, you can install CPU-Z Portable. If your hardware only supports SSE, you may download Audacity Portable 2.0.6 Rev 2 from http://sourceforge.net/projects/portableapps/files/Audacity%20Portable/"
	${EndIf}
	ContinueExection:
!macroend

${SegmentPreExecPrimary}
	ReadINIStr $0 "$EXEDIR\App\Audacity\Portable Settings\audacity.cfg" "Directories" "TempDir"
	${WordReplace} $0 "\\" "?" "+" $1
	${WordReplace} $1 "?" "\" "+" $1
	${GetRoot} $1 $2
	${GetRoot} $EXEDIR $3

	${IfNot} ${FileExists} "$1\*.*"
	${OrIf} $1 == ""
	${OrIf}  $2 != $3
		ReadINIStr $0 "$EXEDIR\Data\settings\AudacityPortableSettings.ini" "AudacityInternalPaths" "TempDir"
		WriteINIStr "$EXEDIR\App\Audacity\Portable Settings\audacity.cfg" "Directories" "TempDir" $0
	${EndIf}
!macroend