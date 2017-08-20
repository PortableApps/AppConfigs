#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile_type=a3x
#AutoIt3Wrapper_icon=xenon.ico
#AutoIt3Wrapper_outfile=..\..\App\XenonPortableA.a3x
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=Xenon Portable
#AutoIt3Wrapper_Res_LegalCopyright=MI3 Software (www.mi3soft.info)
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs

    Xenon File Manager - Open source, portable file manager
    Copyright (C) 2007-2008 www.mi3soft.info
	
	Xenon File Manager is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	One Exception:
		Small snippets of code may be used from Xenon withouth subjecting
		your code to the GNU Lesser General Public License if
			a) The code borrowed does not include more than four (4) functions.
			and
			b) The application that this code will be used in is not a file browser. MI3 Software will decide if the application is a file manager.
	
#ce

#Region
#EndRegion

EnvSet("XENON_DATA_DIR", @ScriptDir & "\..\Data\settings");
EnvSet("XENON_PLUGINS_DIR", @ScriptDir & "\..\App\xenon\plugins");
EnvSet("XENON_LANG_DIR", @ScriptDir & "\xenon\lang");

Dim $script = "Xenon.a3x";

If $CmdLine[0] > 0 Then
	If $CmdLine[1] = "/Search" Then
		$script = "Search.a3x";
	EndIf
EndIf

; Create any missing directories
If Not FileExists(@ScriptDir & "\..\Data\settings") Then DirCreate(@ScriptDir & "\..\Data\settings");

; Preload language file if settings don't exist.
If Not FileExists(@ScriptDir & "\..\Data\settings\settings.ini") Then
	If FileExists(EnvGet("XENON_LANG_DIR") & "\lang_" & EnvGet("PortableApps.comLanguageCode") & ".ini") Then
		IniWrite(@ScriptDir & "\..\Data\settings\settings.ini", "Xenon", "language", "lang_" & EnvGet("PortableApps.comLanguageCode") & ".ini");
	EndIf
EndIf

If Not FileExists(@ScriptDir & "\..\Data\settings\assoc.ini") Then
	;If MsgBox(0x4, "", "Would you like to enable default file assocations?" & @CRLF & @CRLF & "This will allow xenon to open documents, zip files, etc. with portable applications that are already installed.") = 6 Then
		FileInstall("assoc_exe.ini", @ScriptDir & "\..\Data\settings\assoc.ini");
		
		Dim $assocs[38][3] = [ _
			["7z", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["arj", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["bz2", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["cab", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["gz", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["rar", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["z", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["zip", "..\7-ZipPortable\7-ZipPortable.exe", "|XEDIR|\..\6-Zip\6-Zip.a3x"], _
			["au3", "..\Notepad++Portable\Notepad++Portable.exe", "\..\CommonFiles\AutoIt\AutoIt3A.exe"], _
			["bat", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["cmd", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["au3", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["ini", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["js", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["nsh", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["nsi", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\..\NSISPortable\NSISPortable.exe"], _
			["vbs", "..\Notepad++Portable\Notepad++Portable.exe", "|XEDIR|\notepad.au3"], _
			["doc", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["eps", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["odg", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["odp", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["ods", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["odt", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["otg", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["ots", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["ott", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["pps", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["ppt", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["wpd", "..\OpenOfficePortable\OpenOfficePortable.exe", ""], _
			["html", "..\FirefoxPortable\FirefoxPortable.exe", ""], _
			["htm", "..\FirefoxPortable\FirefoxPortable.exe", ""], _
			["url", "..\FirefoxPortable\FirefoxPortable.exe", ""], _
			["mp3", "..\VLCPortable\VLCPortable.exe", ""], _
			["mpg", "..\VLCPortable\VLCPortable.exe", ""], _
			["ogg", "..\VLCPortable\VLCPortable.exe", ""], _
			["wma", "..\VLCPortable\VLCPortable.exe", ""], _
			["wmv", "..\VLCPortable\VLCPortable.exe", ""], _
			["pdf", "..\SumatraPDFPortable\SumatraPDFPortable.exe", ""] _
		];
		
		Dim $i;
		For $i = 0 To UBound($assocs) - 1
			If FileExists(@ScriptDir & "\..\" & $assocs[$i][1]) Then
				IniWrite(@ScriptDir & "\..\Data\settings\assoc.ini", $assocs[$i][0], "exe", StringTrimLeft(@ScriptDir & "\..\" & $assocs[$i][1], 2));
				If FileExists(@ScriptDir & "\..\" & $assocs[$i][2]) And $assocs[$i][2] <> "" Then
					IniWrite(@ScriptDir & "\..\Data\settings\assoc.ini", $assocs[$i][0], "start", StringTrimLeft(@ScriptDir & "\" & $assocs[$i][2], 2));
				EndIf
			EndIf
		Next
	;Else
	;	FileInstall("assoc.ini", @ScriptDir & "\..\Data\settings\")
	;EndIf
EndIf

Dim $process = ShellExecute(@AutoItExe, "/AutoIt3ExecuteScript """ & StringReplace(@ScriptDir, """", """""") & "\xenon\" & $script & """ " & _
	$CmdLineRaw & " " & IniRead(@ScriptDir & "\..\XenonPortable.ini", "XenonPortable", "AditionalParameters", ""));

If Not Int(IniRead(@ScriptDir & "\..\XenonPortable.ini", "XenonPortable", "DisableSplashScreen", "0")) Then
	Local $tmp;
	Do
		$tmp = @TempDir & "\XETMP" & Random();
	Until Not FileExists($tmp);
	DirCreate($tmp);
	FileInstall("XenonPortable.jpg", $tmp & "\XenonPortable.jpg");
	SplashImageOn("Xenon Portable", $tmp & "\XenonPortable.jpg", 414, 247, Default, Default, 1);
	Sleep(1000);
	SplashOff();
	DirRemove($tmp, 1);
EndIf