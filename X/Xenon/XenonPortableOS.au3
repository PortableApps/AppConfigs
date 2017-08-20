#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=xenon.ico
#AutoIt3Wrapper_outfile=..\..\XenonPortable.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Description=Xenon Portable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;If @OSArch = "IA64" Or @OSArch = "X64" Then
;	Run("""" & @ScriptDir & IniRead(@ScriptDir & "\XenonPortable.ini", "XenonPortable", "x64", "\App\XenonPortable64.exe") & """");
If @OSTYPE = "WIN32_WINDOWS" Then
	Run("""" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptDir & IniRead(@ScriptDir & "\XenonPortable.ini", "XenonPortable", "ANSI", "\App\XenonPortableA.a3x") & """");
Else
	Run("""" & @ScriptDir & IniRead(@ScriptDir & "\XenonPortable.ini", "XenonPortable", "Unicode", "\App\XenonPortableW.exe") & """");
EndIf