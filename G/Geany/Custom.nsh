${SegmentFile}

!addincludedir "${PACKAGE}\App\AppInfo\Launcher"
!include StrReplace.nsh

Var CustomLastDrive
Var CustomCurrentDrive
Var CustomCurrentDirectory
Var CustomLastDirectory
Var CustomPortableAppsBaseDirectory
Var CustomLastPortableAppsBaseDirectory

/* The following 5 macros are taken from PAL's Variables.nsh, and adjusted in order to create
 * a new environment variable using HTML encoding, as required by this app
 */ 

!define SetEnvironmentVariablesPathCustom "!insertmacro SetEnvironmentVariablesPathCallCustom"
!macro SetEnvironmentVariablesPathCallCustom _VARIABLE_NAME _PATH
	Push "${_VARIABLE_NAME}"
	Push "${_PATH}"
	${CallArtificialFunction2} SetEnvironmentVariablesPathCustom_
!macroend

!macro SetEnvironmentVariablesPathCustom_
	/* This function sets environment variables with different formats for paths.
	 * For example:
	 *   ${SetEnvironmentVariablesPath} PortableApps.comAppDirectory $EXEDIR\App
	 * Will produce the following environment variables:
	 *   %PAL:AppDir%                 = X:\PortableApps\AppNamePortable\App
	 *   %PAL:AppDir:Forwardslash%    = X:/PortableApps/AppNamePortable/App
	 *   %PAL:AppDir:DoubleBackslash% = X:\\PortableApps\\AppNamePortable\\App
	 *   %PAL:AppDir:java.util.prefs% = /X:///Portable/Apps///App/Name/Portable///App
	 */
	Exch $R0 ; path
	Exch
	Exch $R1 ; variable name

	Push $R2 ; HTML colon
	
	Push $R3 ; HTML backslash
	
	;=== Make the HTML path (e.g. X%3A%5CPortableApps%5CAppNamePortable)
	${WordReplace} $R0 : %3A + $R2
	${WordReplace} $R2 \ %5C + $R3
	${SetEnvironmentVariable} "$R1" $R3
!macroend

!macro SetEnvironmentVariablesPathFromEnvironmentVariableCustom _VARIABLE_NAME
	Push $R0
	ReadEnvStr $R0 "${_VARIABLE_NAME}"
	${SetEnvironmentVariablesPathCustom} "${_VARIABLE_NAME}" $R0
	Pop $R0
!macroend
!define SetEnvironmentVariablesPathFromEnvironmentVariableCustom "!insertmacro SetEnvironmentVariablesPathFromEnvironmentVariableCustom"

; Geany variables
Var GTKBookmarks
Var ExistsXBEL
Var ExistsFileChooser

${Segment.OnInit}
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0 ;32bit
		${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Geany"
	${Else} ;64bit
		${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\Geany64"
	${EndIf}
!macroend

${SegmentInit}
	${ReadUserConfig} $0 PathAdditions
	${IfNot} $0 == ""
		StrCpy $1 "" 
		StrCmp $0 "" +4 0
		${GetRoot} $EXEDIR $1
		${StrReplace} '$1' '@Drive' '$1' '$0'
		WriteINIStr "$EXEDIR\App\AppInfo\Launcher\$AppID.ini" Environment PATH "%PAL:AppDir%\Geany\bin;%PAL:AppDir%\Geany;$0;%PATH%"
	${EndIf}
!macroend

${SegmentPre}
	; Customize DriveLetter for HTML Encoding
	ReadINIStr $CustomLastDrive $EXEDIR\Data\settings\$AppIDSettings.ini $AppIDSettings LastDrive
	${GetRoot} $EXEDIR $CustomCurrentDrive
	${IfThen} $CustomLastDrive == "" ${|} StrCpy $CustomLastDrive $CustomCurrentDrive ${|}

	StrCpy $0 $CustomCurrentDrive 1
	StrCpy $1 $CustomLastDrive 1
	${SetEnvironmentVariable} CustomDriveLetter $0
	${SetEnvironmentVariable} CustomLastDriveLetter $1
	
	; Customize Package Partial Directory for HTML Encoding
	${GetRoot} $EXEDIR $2
	StrLen $2 $2
	StrCpy $CustomCurrentDirectory $EXEDIR '' $2
	${If} $CustomCurrentDirectory == ''
		StrCpy $CustomCurrentDirectory '\'
	${EndIf}
	${SetEnvironmentVariablesPathCustom} CustomPackagePartialDir $CustomCurrentDirectory
	
	ReadINIStr $CustomLastDirectory $EXEDIR\Data\settings\$AppIDSettings.ini $AppIDSettings LastDirectory
	${IfThen} $CustomLastDirectory == "" ${|} StrCpy $CustomLastDirectory $CustomCurrentDirectory ${|}
	${SetEnvironmentVariablesPathCustom} CustomLastPackagePartialDir $CustomLastDirectory
	
	; Customize PortableAppsBaseDir for HTML Encoding	
	${GetParentUNC} $PortableAppsDirectory $CustomPortableAppsBaseDirectory
	${SetEnvironmentVariablesPathCustom} CustomPortableAppsBaseDir $CustomPortableAppsBaseDirectory

	ReadINIStr $CustomLastPortableAppsBaseDirectory $DataDirectory\settings\$AppIDSettings.ini PortableApps.comLauncherLastRunEnvironment PAL:LastPortableAppsBaseDir
	
	${SetEnvironmentVariablesPathCustom} CustomLastPortableAppsBaseDir $CustomLastPortableAppsBaseDirectory
!macroend

${SegmentPrePrimary}
	IfFileExists "$USERPROFILE\.recently-used.xbel" 0 +2 
		StrCpy $ExistsXBEL "true"
	IfFileExists "$USERPROFILE\.gtk-bookmarks" 0 +2
		StrCpy $GTKBookmarks "true"
	IfFileExists "$APPDATA\gtk-2.0\gtkfilechooser.ini" 0 +2
		StrCpy $ExistsFileChooser "true"
	Delete "$EXEDIR\DataDir\settings\geany.conf.old"
	Delete "$EXEDIR\DataDir\settings\plugins\spellcheck\spellcheck.conf.old"
!macroend

${SegmentPost}
	StrCmp $ExistsXBEL "true" +2
		Delete "$USERPROFILE\.recently-used.xbel"
	StrCmp $GTKBookmarks "true" +2
		Delete "$USERPROFILE\.gtk-bookmarks"
	StrCmp $ExistsFileChooser "true" +2
		Delete "$APPDATA\gtk-2.0\gtkfilechooser.ini"
!macroend