;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include CustomRemoveFilesAndSubDirs.nsh
!include ReplaceInFileWithTextReplace.nsh

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "7.0.0.0" $R0
		${If} $R0 = 2
			${GetParent} $INSTDIR $1
			${IfNot} ${FileExists} "$1\MaxthonPortableLegacy4\*.*"
				${GetParent} $INSTDIR $1
				CreateDirectory "$1\MaxthonPortableLegacy4"
				CopyFiles /SILENT /FILESONLY "$INSTDIR\*.*" "$1\MaxthonPortableLegacy4"
				CreateDirectory "$1\MaxthonPortableLegacy4\App"
				CopyFiles /SILENT "$INSTDIR\App\*.*" "$1\MaxthonPortableLegacy4\App"
				Rename "$INSTDIR\Data" "$1\MaxthonPortableLegacy4\Data"
				CreateDirectory "$1\MaxthonPortableLegacy4\Other"
				CopyFiles /SILENT "$INSTDIR\Other\*.*" "$1\MaxthonPortableLegacy4\Other"
				WriteINIStr "$1\MaxthonPortableLegacy4\App\AppInfo\AppInfo.ini" "Details" "AppID" "MaxthonPortableLegacy4"
				WriteINIStr "$1\MaxthonPortableLegacy4\App\AppInfo\AppInfo.ini" "Details" "Name" "Maxthon Portable (Legacy 4.x)"
				WriteINIStr "$1\MaxthonPortableLegacy4\App\AppInfo\AppInfo.ini" "Control" "BaseAppID" "Maxthon4"
				WriteINIStr "$1\MaxthonPortableLegacy4\App\AppInfo\AppInfo.ini" "Format" "Version" "3.7"
			${EndIf}
		${Else}
			${VersionCompare} $0 "7.3.1.6200" $R0
			${If} $R0 = 2
			${AndIf} ${FileExists} "$INSTDIR\Data\UserData\Local State"
				;Disable background tasks by default
				${ReplaceInFile} "$INSTDIR\Data\UserData\Local State" `,"background_tracing"` `,"background_mode":{"enabled":false},"background_tracing"`
			${EndIf}
		${EndIf}
	${ElseIf} ${FileExists} "$INSTDIR\User Data\Default\*.*"
		;Upgrade from non-PA.c version
		${GetParent} $INSTDIR $1
		${IfNot} ${FileExists} "$1\MaxthonPortablePublisher\*.*"
			CreateDirectory "$1\MaxthonPortablePublisher"
			CopyFiles /SILENT "$INSTDIR\*.*" "$1\MaxthonPortablePublisher"
			!insertmacro RemoveFilesAndSubDirs "$INSTDIR"
			CreateDirectory "$INSTDIR\Data"
			CreateDirectory "$INSTDIR\Data\UserData"
			CopyFiles /SILENT "$1\MaxthonPortablePublisher\User Data" "$INSTDIR\Data\UserData"	
		${EndIf}
	${EndIf}
!macroend