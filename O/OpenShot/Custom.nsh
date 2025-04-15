${SegmentFile}

!addplugindir `${PACKAGE}\App\AppInfo\Launcher`

Var LangValue
Var BlenderValue
Var InkscapeValue

${SegmentInit}
    ${If} $Bits = 64
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\OpenShot64"
		Rename "$EXEDIR\App\OpenShot\blender" "$EXEDIR\App\OpenShot64\blender"
		Rename "$EXEDIR\App\OpenShot\classes" "$EXEDIR\App\OpenShot64\classes"
		Rename "$EXEDIR\App\OpenShot\effects" "$EXEDIR\App\OpenShot64\effects"
		Rename "$EXEDIR\App\OpenShot\emojis" "$EXEDIR\App\OpenShot64\emojis"
		Rename "$EXEDIR\App\OpenShot\images" "$EXEDIR\App\OpenShot64\images"
		Rename "$EXEDIR\App\OpenShot\language" "$EXEDIR\App\OpenShot64\language"
		Rename "$EXEDIR\App\OpenShot\presets" "$EXEDIR\App\OpenShot64\presets"
		Rename "$EXEDIR\App\OpenShot\profiles" "$EXEDIR\App\OpenShot64\profiles"
		Rename "$EXEDIR\App\OpenShot\PyQt5.uic.widget-plugins" "$EXEDIR\App\OpenShot64\PyQt5.uic.widget-plugins"
		Rename "$EXEDIR\App\OpenShot\resources" "$EXEDIR\App\OpenShot64\resources"
		Rename "$EXEDIR\App\OpenShot\tests" "$EXEDIR\App\OpenShot64\tests"
		Rename "$EXEDIR\App\OpenShot\themes" "$EXEDIR\App\OpenShot64\themes"
		Rename "$EXEDIR\App\OpenShot\timeline" "$EXEDIR\App\OpenShot64\timeline"
		Rename "$EXEDIR\App\OpenShot\titles" "$EXEDIR\App\OpenShot64\titles"
		Rename "$EXEDIR\App\OpenShot\transitions" "$EXEDIR\App\OpenShot64\transitions"
		Rename "$EXEDIR\App\OpenShot\windows" "$EXEDIR\App\OpenShot64\windows"
	${Else}
        ${SetEnvironmentVariablesPath} FullAppDir "$EXEDIR\App\OpenShot"
		Rename "$EXEDIR\App\OpenShot64\blender" "$EXEDIR\App\OpenShot\blender"
		Rename "$EXEDIR\App\OpenShot64\classes" "$EXEDIR\App\OpenShot\classes"
		Rename "$EXEDIR\App\OpenShot64\effects" "$EXEDIR\App\OpenShot\effects"
		Rename "$EXEDIR\App\OpenShot64\emojis" "$EXEDIR\App\OpenShot\emojis"
		Rename "$EXEDIR\App\OpenShot64\images" "$EXEDIR\App\OpenShot\images"
		Rename "$EXEDIR\App\OpenShot64\language" "$EXEDIR\App\OpenShot\language"
		Rename "$EXEDIR\App\OpenShot64\presets" "$EXEDIR\App\OpenShot\presets"
		Rename "$EXEDIR\App\OpenShot64\profiles" "$EXEDIR\App\OpenShot\profiles"
		Rename "$EXEDIR\App\OpenShot64\PyQt5.uic.widget-plugins" "$EXEDIR\App\OpenShot\PyQt5.uic.widget-plugins"
		Rename "$EXEDIR\App\OpenShot64\resources" "$EXEDIR\App\OpenShot\resources"
		Rename "$EXEDIR\App\OpenShot64\tests" "$EXEDIR\App\OpenShot\tests"
		Rename "$EXEDIR\App\OpenShot64\themes" "$EXEDIR\App\OpenShot\themes"
		Rename "$EXEDIR\App\OpenShot64\timeline" "$EXEDIR\App\OpenShot\timeline"
		Rename "$EXEDIR\App\OpenShot64\titles" "$EXEDIR\App\OpenShot\titles"
		Rename "$EXEDIR\App\OpenShot64\transitions" "$EXEDIR\App\OpenShot\transitions"
		Rename "$EXEDIR\App\OpenShot64\windows" "$EXEDIR\App\OpenShot\windows"
	${EndIf}
!macroend

${SegmentPrePrimary}
	${If} ${FileExists} "$EXEDIR\Data\.openshot_qt\openshot.settings-old"
	${AndIfNot} ${FileExists} "$EXEDIR\Data\.openshot_qt\openshot.settings"
		ReadINIStr $0 "$EXEDIR\Data\settings\OpenShotPortableSettings.ini" "OpenShotPortableSettings" "ResetBrokenPreferences310"
		${If} $0 != true
			ClearErrors
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\.openshot_qt\openshot.settings" "$EXEDIR\Data\.openshot_qt"
			MessageBox MB_ICONINFORMATION|MB_OK "Your OpenShot Portable settings have been reset due to a bug within OpenShot causing a crash on start. Your old settings have been preserved as:$\r$\nOpenShotPortable\Data\.openshot_qt\openshot.settings-old"
			WriteINIStr "$EXEDIR\Data\settings\OpenShotPortableSettings.ini" "OpenShotPortableSettings" "ResetBrokenPreferences310" "true"
		${EndIf}
	${EndIf}
!macroend

${SegmentPre}
	ReadEnvStr $0 "PortableApps.comLocaleName"
	ReadEnvStr $1 "PortableApps.comLocaleName_INTERNAL"
	ReadEnvStr $2 "PAL:PortableAppsDir"
	
	${If} $0 != ""
	${AndIf} $0 == $1		
		;Only do language switching with the platform
		ReadEnvStr $0 PAL:LanguageCustom
			  		
		ClearErrors
		nsJSON::Set /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
		nsJSON::Get /index 0 "value" /end
		Pop $LangValue
		IfErrors write
		
		${If} $0 != $LangValue
			write:
			nsJSON::Set /index 0 "value" /value "$0"
			IfErrors done
		${EndIf}
		done:
		nsJSON::Serialize /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
	${EndIf}
	
	${If} ${FileExists} "$2\BlenderPortable\*.*" ; Only write value if Blender Portable exists
		StrCpy $3 "$2\BlenderPortable\BlenderPortable.exe"
		ClearErrors
		nsJSON::Set /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
		nsJSON::Get /index 5 "value" /end
		Pop $BlenderValue
		IfErrors write2
		
		${If} $3 != $BlenderValue
			write2:
			nsJSON::Set /index 5 "value" /value "$3"
			IfErrors done2
		${EndIf}
		done2:
		nsJSON::Serialize /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
	${EndIf}
	
	${If} ${FileExists} "$2\InkscapePortable\*.*" ; Only write value if Inkscape Portable exists
		StrCpy $4 "$2\InkscapePortable\InkscapePortable.exe"
		ClearErrors
		nsJSON::Set /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
		nsJSON::Get /index 6 "value" /end
		Pop $InkscapeValue
		IfErrors write3
		
		${If} $3 != $InkscapeValue
			write3:
			nsJSON::Set /index 6 "value" /value "$4"
			IfErrors done3
		${EndIf}
		done3:
		nsJSON::Serialize /file "$EXEDIR\Data\.openshot_qt\openshot.settings"
	${EndIf}
!macroend

${SegmentPostPrimary}
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
!macroend