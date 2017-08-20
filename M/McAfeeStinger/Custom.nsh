${SegmentFile}

${Segment.OnInit}
	Delete "$EXEDIR\Data\settings\stinger.sys"
	Delete "$EXEDIR\Data\settings\mfevtps.exe.6398.deleteme"
	
	MessageBox MB_OK|MB_ICONEXCLAMATION "WARNING! Before clicking scan, be sure to close all other running applications on your system. McAfee Stinger will force close some processes including unrelated apps like FileZilla which can cause a loss of data.  After scanning, run McAfee Stinger Portable a second time and then close the application (without clicking scan) so that files can be properly cleaned up. Some files may be left behind on Windows XP."
!macroend
