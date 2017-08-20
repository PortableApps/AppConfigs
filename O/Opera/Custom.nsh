${SegmentFile}

!define PF_XMMI64_INSTRUCTIONS_AVAILABLE 10

${SegmentInit}
	;Ensure processor supports SSE2
	System::Call kernel32::IsProcessorFeaturePresent(i${PF_XMMI64_INSTRUCTIONS_AVAILABLE})i.r0
	${If} $0 == 0
		;SSE2 unavailable
		MessageBox MB_ICONEXCLAMATION|MB_OK "This computer has an older CPU that lacks SSE2 instruction set support. This application can not run on this computer."
		Abort
	${EndIf}

	;Determine version of opera that will be run
	${If} ${FileExists} "$EXEDIR\App\Opera\launcher.exe"
		MoreInfo::GetProductVersion "$EXEDIR\App\Opera\launcher.exe"
		Pop $0
		${SetEnvironmentVariablesPath} CustomCodeOperaVersion "$0"
	${Else}
		${SetEnvironmentVariablesPath} CustomCodeOperaVersion "NONE"
	${EndIf}
!macroend

${SegmentPrePrimary}
	;Determine if run from the PortableApps.com Platform
	ReadEnvStr $1 "PortableApps.comPlatformVersion"
	${If} $1 == ""
		;Hack for platform 14.1 and earlier
		ReadEnvStr $1 "PortableApps.comLanguageCode_INTERNAL"
	${EndIf}
	
	;Disable or enable internal Opera updater if run or not run from PortableApps.com Platform
	ReadEnvStr $0 "CustomCodeOperaVersion"
	${If} $1 == ""
		;Platform not running
		${If} ${FileExists} "$EXEDIR\App\Opera\$0\opera_autoupdate.exe.disabled"
			Rename "$EXEDIR\App\Opera\$0\opera_autoupdate.exe.disabled" "$EXEDIR\App\Opera\$0\opera_autoupdate.exe"
		${EndIf}
	${Else}
		;Platform running
		${If} ${FileExists} "$EXEDIR\App\Opera\$0\opera_autoupdate.exe"
			Rename "$EXEDIR\App\Opera\$0\opera_autoupdate.exe" "$EXEDIR\App\Opera\$0\opera_autoupdate.exe.disabled"
		${EndIf}
	${EndIf}
	
	${If} ${FileExists} "$EXEDIR\App\Opera\profile\data\*.*"
		${If} ${FileExists} "$EXEDIR\Data\profile\*.*"
			MessageBox MB_ICONEXCLAMATION|MB_OK "A duplicate profile was found stored in $EXEDIR\App\Opera\profile when attempting to start Opera Portable.  This can be due to a failure to close Opera Portable the last time it was used or accidentally running Opera directly by setting it as your default browser.  Please ensure that no profile is stored in that location and that the profile you would like to use is within $EXEDIR\Data\profile before continuing. Do not delete either profile until you determine which contains your full profile and which was created accidentally."
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
	${Else}
		${If} ${FileExists} "$EXEDIR\App\Opera\profile\*.*"
			;Remove profile remnants
			RMDir /r "$EXEDIR\App\Opera\profile"
			${If} ${FileExists} "$EXEDIR\App\Opera\profile\*.*"
				MessageBox MB_ICONEXCLAMATION|MB_OK "Remnants of another profile were found stored in $EXEDIR\App\Opera\profile when attempting to start Opera Portable.  The launcher was unable to remove these files. Please ensure no other processes are locking any of the files and there are no errors on the drive Opera Portable is stored on before continuing."
				${registry::Unload}
				Abort
			${EndIf}
		${EndIf}
	${EndIf}
!macroend