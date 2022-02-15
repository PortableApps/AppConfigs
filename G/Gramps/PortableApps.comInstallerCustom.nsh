!insertmacro GetParent

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "5.1.3.0" $R0
		${If} $R0 == 2
		${AndIf} ${FileExists} "$INSTDIR\Data\settings\gramps\*.*"
			${GetParent} $INSTDIR $1
			CreateDirectory "$1\GrampsPortableLegacy"
			Rename "$INSTDIR\App" "$1\GrampsPortableLegacy\App"
			CreateDirectory "$1\GrampsPortableLegacy\Data"
			CopyFiles /SILENT "$INSTDIR\Data\*.*" "$1\GrampsPortableLegacy\Data"
			Rename "$INSTDIR\Other" "$1\GrampsPortableLegacy\Other"
			Rename "$INSTDIR\GrampsPortable.exe" "$1\GrampsPortableLegacy\GrampsPortable.exe"
			CopyFiles /SILENT "$INSTDIR\GrampsPortable.ini" "$1\GrampsPortableLegacy"
			Rename "$INSTDIR\help.html" "$1\GrampsPortableLegacy\help.html"
			WriteINIStr "$1\GrampsPortableLegacy\App\AppInfo\appinfo.ini" "Details" "Name" "Gramps Portable Legacy"
			WriteINIStr "$1\GrampsPortableLegacy\App\AppInfo\appinfo.ini" "Details" "AppID" "GrampsPortableLegacy"
		${EndIf}
	${EndIf}
!macroend

!macro CustomCodePostInstall
	${If} ${FileExists} "$INSTDIR\App\Gramps\share\enchant\myspell-all\*.*"
		Rename "$INSTDIR\App\Gramps\share\enchant\myspell\en_US.aff" "$INSTDIR\App\Gramps\share\enchant\myspell-all\en_US.aff"
		Rename "$INSTDIR\App\Gramps\share\enchant\myspell\en_US.dic" "$INSTDIR\App\Gramps\share\enchant\myspell-all\en_US.dic"
		RMDir "$INSTDIR\App\Gramps\share\enchant\myspell"
		Rename "$INSTDIR\App\Gramps\share\enchant\myspell-all" "$INSTDIR\App\Gramps\share\enchant\myspell"
	${EndIf}
!macroend