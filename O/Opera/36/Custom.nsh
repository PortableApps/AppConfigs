${SegmentFile}

${SegmentPrePrimary}
	${If} ${FileExists} "$EXEDIR\App\Opera\profile\data\*.*"
		${If} ${FileExists} "$EXEDIR\Data\profile\*.*"
			MessageBox MB_ICONEXCLAMATION|MB_OK "A duplicate profile was found stored in $EXEDIR\App\Opera\profile when attempting to start Opera Portable.  This can be due to a failure to close Opera Portable the last time it was used or accidentally running Opera directly by setting it as your default browser.  Please ensure that no profile is stored in that location and that the profile you would like to use is within $EXEDIR\Data\profile before continuing."
			${registry::Unload}
			Abort
		${Else}
			Rename "$EXEDIR\App\Opera\profile" "$EXEDIR\Data\profile"
			${If} ${FileExists} "$EXEDIR\Data\profile\*.*"
				MessageBox MB_ICONEXCLAMATION|MB_OK "Your profile was found stored in $EXEDIR\App\Opera\profile when attempting to start Opera Portable.  This can be due to a failure to close Opera Portable the last time it was used or accidentally running Opera directly by setting it as your default browser.  Your profile has been moved back to $EXEDIR\Data\profile. Please start Opera Portable again to continue."
				${registry::Unload}
				Abort
			${Else}
				MessageBox MB_ICONEXCLAMATION|MB_OK "Your profile was found stored in $EXEDIR\App\Opera\profile when attempting to start Opera Portable.  This can be due to a failure to close Opera Portable the last time it was used or accidentally running Opera directly by setting it as your default browser.  The launcher was unable to move your profile back to $EXEDIR\Data\profile. Please ensure no other processes are locking any of the files and there are no errors on the drive Opera Portable is stored on before continuing."
				${registry::Unload}
				Abort
			${EndIf}
		${EndIf}
	${EndIf}
!macroend