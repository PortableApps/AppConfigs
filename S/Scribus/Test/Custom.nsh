${SegmentFile}

Var CustomBits

Var GSMode
Var GSDirectory
Var GSRegExists
Var GSExecutable

Function _Ghostscript_ValidateInstall
	${If} $Bits = 64
		${If} ${FileExists} $GSDirectory\bin\gswin64c.exe
			StrCpy $GSExecutable $GSDirectory\bin\gswin64c.exe
			;${DebugMsg} "Found valid 64-bit Ghostscript install at $GSDirectory."
			StrCpy $R8 "Found valid 64-bit Ghostscript install at $GSDirectory."
			Push true
			Goto End
		${Else}
			;${DebugMsg} "64-bit Windows but gswin64c.exe not found; trying gswin32c.exe instead."
			StrCpy $R8 "64-bit Windows but gswin64c.exe not found; trying gswin32c.exe instead.$\r$\n"
		${EndIf}
	${EndIf}

	${IfNot} ${FileExists} $GSDirectory\bin\gswin32c.exe
		StrCpy $GSDirectory ""
		StrCpy $GSExecutable ""
		;${DebugMsg} "No valid Ghostscript install found at $GSDirectory."
		StrCpy $R8 "$R8No valid Ghostscript install found at $GSDirectory."
		Push false
		Goto End
	${EndIf}

	StrCpy $GSExecutable $GSDirectory\bin\gswin32c.exe
	;${DebugMsg} "Found valid 32-bit Ghostscript install at $GSDirectory."
	StrCpy $R8 "$R8Found valid 32-bit Ghostscript install at $GSDirectory."
	Push true
	Goto End

	End:
FunctionEnd
!macro _Ghostscript_ValidateInstall _a _b _t _f
	!insertmacro _LOGICLIB_TEMP
	;${DebugMsg} "Checking for Ghostscript in $GSDirectory..."
	${DebugMsg} `$R8`
	Call _Ghostscript_ValidateInstall
	Pop $_LOGICLIB_TEMP
	!insertmacro _== $_LOGICLIB_TEMP true `${_t}` `${_f}`
!macroend
!define IsValidGhostscriptInstall `"" Ghostscript_ValidateInstall ""`

${Segment.OnInit}
	; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0
		StrCpy $Bits 32
	${Else}
		StrCpy $Bits 64
	${EndIf}
	
	StrCpy $0 $Bits
	${SetEnvironmentVariable} CustomBits $0
!macroend

${SegmentInit}
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
!macroend

${SegmentPre}	
	; If [Activate]:Ghostscript=find|require, search for Ghostscript in the
	; following locations (in order):
	;
	;  - PortableApps.com CommonFiles (..\CommonFiles\Ghostscript)
	;  - GS_PROG (which will be $GSDirectory\bin\gswin(32|64)c.exe)
	;  - Anywhere in %PATH% (with SearchPath)
	;
	; If it's in none of those, give up. [Activate]:Ghostscript=require will
	; then abort, [Activate]:Ghostscript=find will not set it.
	ClearErrors
	${ReadLauncherConfig} $GSMode Activate Ghostscript
	${If} $GSMode == find
	${OrIf} $GSMode == require
		StrCpy $GSDirectory $PortableAppsDirectory\CommonFiles\Ghostscript
		${IfNot} ${IsValidGhostscriptInstall}
			ReadEnvStr $GSDirectory GS_PROG
			${GetParent} $GSDirectory $GSDirectory
			${GetParent} $GSDirectory $GSDirectory
			${IfNot} ${IsValidGhostscriptInstall}
				ClearErrors
				SearchPath $GSDirectory gswin32c.exe
				${GetParent} $GSDirectory $GSDirectory
				${GetParent} $GSDirectory $GSDirectory
				${IfNot} ${IsValidGhostscriptInstall}
					; If not valid, ${IsValidGhostscriptInstall} will clear
					; $GSDirectory for us.
					Nop
				${EndIf}
			${EndIf}
		${EndIf}

		; If Ghostscript is required and not found, quit
		${If} $GSMode == require
		${AndIf} $GSDirectory == ""
			MessageBox MB_OK|MB_ICONSTOP `$(LauncherNoGhostscript)`
			Quit
		${EndIf}

		; This may be created; check if it exists before: 0 = exists
		${registry::KeyExists} "HKCU\Software\GPL Ghostscript" $GSRegExists

		${DebugMsg} "Selected Ghostscript path: $GSDirectory"
		${DebugMsg} "Selected Ghostscript executable: $GSExecutable"
		ReadEnvStr $0 PATH
		StrCpy $0 "$0;$GSDirectory\bin"
		${SetEnvironmentVariablesPath} PATH $0
		${SetEnvironmentVariablesPath} GS_PROG $GSExecutable
	${ElseIfNot} ${Errors}
		${InvalidValueError} [Activate]:Ghostscript $GSMode
	${EndIf}
!macroend

${SegmentPost}
	${If} $GSRegExists != 0  ; Didn't exist before
	${AndIf} ${RegistryKeyExists} "HKCU\Software\GPL Ghostscript"
		${registry::DeleteKey} "HKCU\Software\GPL Ghostscript" $R9
	${EndIf}
!macroend

${SegmentPostPrimary}
	; Copied in and modified from PAL for Qt 5.0 - now using QtProject vs. Trolltech
	;
	; The Qt plugin cache and a few other things leave keys inside
	; HKCU\Software\QtProject\OrganizationDefaults\*\X:\...\dirname which need
	; to be cleared up. They're useless, they've got just values like foo.dll
	; with a version number in them, but they need removing. Due to the
	; directory-recursive key nature of them, we can just scrap the package
	; directory for each and then prune the tree as far up as it's empty.
	StrCpy $R0 1
	${Do}
		ClearErrors
		${ReadLauncherConfig} $0 QtKeysCleanup $R0
		${IfThen} ${Errors} ${|} ${ExitDo} ${|}
		StrCpy $1 Software\QtProject\OrganizationDefaults\$0\$AppDirectory
		DeleteRegKey HKCU $1
		${Do}
			${GetParent} $1 $1
			DeleteRegKey /ifempty HKCU $1
		${LoopUntil} $1 == "Software\QtProject"

		IntOp $R0 $R0 + 1
	${Loop}
	; We don't need to set $UsesRegistry to true, the registry plug-in hasn't
	; been used and unloading it is what UsesRegistry is for.
!macroend