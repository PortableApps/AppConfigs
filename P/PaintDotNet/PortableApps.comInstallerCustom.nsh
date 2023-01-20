!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "5.0.0.0" $R0
		${If} $R0 == 2
			System::Call kernel32::GetCurrentProcess()i.s
			System::Call kernel32::IsWow64Process(is,*i.r0)
			ReadRegStr $1 HKLM "Software\Microsoft\Windows NT\CurrentVersion" "CurrentBuild"
			${If} $0 == 0 ;Installing on 32-bit Windows
			${OrIf} $1 < 10000 ;Windows 7/8/8.1
				${GetParent} $INSTDIR $1
				CreateDirectory "$1\PaintDotNetPortableLegacyWin7"
				CopyFiles /SILENT "$INSTDIR\*.*" "$1\PaintDotNetPortableLegacyWin7"
				WriteINIStr "$1\PaintDotNetPortableLegacyWin7\App\AppInfo\AppInfo.ini" "Details" "AppID" "PaintDotNetPortableLegacyWin7"
				WriteINIStr "$1\PaintDotNetPortableLegacyWin7\App\AppInfo\AppInfo.ini" "Details" "Name" "paint.net Portable (Legacy Win7)"
			${EndIf}
		${EndIf}
	${EndIf}
!macroend