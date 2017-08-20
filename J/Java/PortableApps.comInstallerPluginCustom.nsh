Var InstallerCustomJavaPluginDisabled

!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\bin\plugin2-disabled\*.*"
		StrCpy $InstallerCustomJavaPluginDisabled true
	${EndIf}
!macroend

!macro CustomCodePostInstall
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\charsets.pack" "$INSTDIR\lib\charsets.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\deploy.pack" "$INSTDIR\lib\deploy.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\javaws.pack" "$INSTDIR\lib\javaws.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\jfxrt.pack" "$INSTDIR\lib\jfxrt.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\jsse.pack" "$INSTDIR\lib\jsse.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\plugin.pack" "$INSTDIR\lib\plugin.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\rt.pack" "$INSTDIR\lib\rt.jar"' "" ""
	;Pop $R0
	;ExecDOS::exec '"$INSTDIR\bin\unpack200.exe" -r -q "$INSTDIR\lib\ext\localedata.pack" "$INSTDIR\lib\ext\localedata.jar"' "" ""
	;Pop $R0
	;CopyFiles /silent "$INSTDIR\bin\npdeployJava1.dll" "$INSTDIR\bin\plugin2"
	;CopyFiles /silent "$INSTDIR\bin\msvcr71.dll" "$INSTDIR\bin\plugin2"
	${If} $InstallerCustomJavaPluginDisabled == true
		Rename "$INSTDIR\bin\plugin2" "$INSTDIR\bin\plugin2-disabled"
	${EndIf}
!macroend
