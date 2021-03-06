${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\PeaZip\peazip64.exe"
			Rename "$EXEDIR\App\PeaZip\peazip.exe" "$EXEDIR\App\PeaZip\peazip32.exe"
			Rename "$EXEDIR\App\PeaZip\peazip64.exe" "$EXEDIR\App\PeaZip\peazip.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\dragdropfilesdll64.dll"
			Rename "$EXEDIR\App\PeaZip\dragdropfilesdll.dll" "$EXEDIR\App\PeaZip\dragdropfilesdll32.dll"
			Rename "$EXEDIR\App\PeaZip\dragdropfilesdll64.dll" "$EXEDIR\App\PeaZip\dragdropfilesdll.dll"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\pea64.exe"
			Rename "$EXEDIR\App\PeaZip\res\pea.exe" "$EXEDIR\App\PeaZip\res\pea32.exe"
			Rename "$EXEDIR\App\PeaZip\res\pea64.exe" "$EXEDIR\App\PeaZip\res\pea.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\pealauncher64.exe"
			Rename "$EXEDIR\App\PeaZip\res\pealauncher.exe" "$EXEDIR\App\PeaZip\res\pealauncher32.exe"
			Rename "$EXEDIR\App\PeaZip\res\pealauncher64.exe" "$EXEDIR\App\PeaZip\res\pealauncher.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\peazip-configuration64.exe"
			Rename "$EXEDIR\App\PeaZip\res\peazip-configuration.exe" "$EXEDIR\App\PeaZip\res\peazip-configuration32.exe"
			Rename "$EXEDIR\App\PeaZip\res\peazip-configuration64.exe" "$EXEDIR\App\PeaZip\res\peazip-configuration.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\7z\7z64.exe"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z.exe" "$EXEDIR\App\PeaZip\res\7z\7z32.exe"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z64.exe" "$EXEDIR\App\PeaZip\res\7z\7z.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\7z\7z64.dll"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z.dll" "$EXEDIR\App\PeaZip\res\7z\7z32.dll"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z64.dll" "$EXEDIR\App\PeaZip\res\7z\7z.dll"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\brotli\brotli64.exe"
			Rename "$EXEDIR\App\PeaZip\res\brotli\brotli.exe" "$EXEDIR\App\PeaZip\res\brotli\brotli32.exe"
			Rename "$EXEDIR\App\PeaZip\res\brotli\brotli64.exe" "$EXEDIR\App\PeaZip\res\brotli\brotli.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\quad\bcm64.exe"
			Rename "$EXEDIR\App\PeaZip\res\quad\bcm.exe" "$EXEDIR\App\PeaZip\res\quad\bcm32.exe"
			Rename "$EXEDIR\App\PeaZip\res\quad\bcm64.exe" "$EXEDIR\App\PeaZip\res\quad\bcm.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\upx\upx64.exe"
			Rename "$EXEDIR\App\PeaZip\res\upx\upx.exe" "$EXEDIR\App\PeaZip\res\upx\upx32.exe"
			Rename "$EXEDIR\App\PeaZip\res\upx\upx64.exe" "$EXEDIR\App\PeaZip\res\upx\upx.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\zpaq\zpaq64.exe"
			Rename "$EXEDIR\App\PeaZip\res\zpaq\zpaq.exe" "$EXEDIR\App\PeaZip\res\zpaq\zpaq32.exe"
			Rename "$EXEDIR\App\PeaZip\res\zpaq\zpaq64.exe" "$EXEDIR\App\PeaZip\res\zpaq\zpaq.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\zstd\zstd64.exe"
			Rename "$EXEDIR\App\PeaZip\res\zstd\zstd.exe" "$EXEDIR\App\PeaZip\res\zstd\zstd32.exe"
			Rename "$EXEDIR\App\PeaZip\res\zstd\zstd64.exe" "$EXEDIR\App\PeaZip\res\zstd\zstd.exe"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\peazip32.exe"
			Rename "$EXEDIR\App\PeaZip\peazip.exe" "$EXEDIR\App\PeaZip\peazip64.exe"
			Rename "$EXEDIR\App\PeaZip\peazip32.exe" "$EXEDIR\App\PeaZip\peazip.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\dragdropfilesdll32.dll"
			Rename "$EXEDIR\App\PeaZip\dragdropfilesdll.dll" "$EXEDIR\App\PeaZip\dragdropfilesdll64.dll"
			Rename "$EXEDIR\App\PeaZip\dragdropfilesdll32.dll" "$EXEDIR\App\PeaZip\dragdropfilesdll.dll"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\pea32.exe"
			Rename "$EXEDIR\App\PeaZip\res\pea.exe" "$EXEDIR\App\PeaZip\res\pea64.exe"
			Rename "$EXEDIR\App\PeaZip\res\pea32.exe" "$EXEDIR\App\PeaZip\res\pea.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\pealauncher32.exe"
			Rename "$EXEDIR\App\PeaZip\res\pealauncher.exe" "$EXEDIR\App\PeaZip\res\pealauncher64.exe"
			Rename "$EXEDIR\App\PeaZip\res\pealauncher32.exe" "$EXEDIR\App\PeaZip\res\pealauncher.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\peazip-configuration32.exe"
			Rename "$EXEDIR\App\PeaZip\res\peazip-configuration.exe" "$EXEDIR\App\PeaZip\res\peazip-configuration64.exe"
			Rename "$EXEDIR\App\PeaZip\res\peazip-configuration32.exe" "$EXEDIR\App\PeaZip\res\peazip-configuration.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\7z\7z32.exe"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z.exe" "$EXEDIR\App\PeaZip\res\7z\7z64.exe"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z32.exe" "$EXEDIR\App\PeaZip\res\7z\7z.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\7z\7z32.dll"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z.dll" "$EXEDIR\App\PeaZip\res\7z\7z64.dll"
			Rename "$EXEDIR\App\PeaZip\res\7z\7z32.dll" "$EXEDIR\App\PeaZip\res\7z\7z.dll"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\brotli\brotli32.exe"
			Rename "$EXEDIR\App\PeaZip\res\brotli\brotli.exe" "$EXEDIR\App\PeaZip\res\brotli\brotli64.exe"
			Rename "$EXEDIR\App\PeaZip\res\brotli\brotli32.exe" "$EXEDIR\App\PeaZip\res\brotli\brotli.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\quad\bcm32.exe"
			Rename "$EXEDIR\App\PeaZip\res\quad\bcm.exe" "$EXEDIR\App\PeaZip\res\quad\bcm64.exe"
			Rename "$EXEDIR\App\PeaZip\res\quad\bcm32.exe" "$EXEDIR\App\PeaZip\res\quad\bcm.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\upx\upx32.exe"
			Rename "$EXEDIR\App\PeaZip\res\upx\upx.exe" "$EXEDIR\App\PeaZip\res\upx\upx64.exe"
			Rename "$EXEDIR\App\PeaZip\res\upx\upx32.exe" "$EXEDIR\App\PeaZip\res\upx\upx.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\zpaq\zpaq32.exe"
			Rename "$EXEDIR\App\PeaZip\res\zpaq\zpaq.exe" "$EXEDIR\App\PeaZip\res\zpaq\zpaq64.exe"
			Rename "$EXEDIR\App\PeaZip\res\zpaq\zpaq32.exe" "$EXEDIR\App\PeaZip\res\zpaq\zpaq.exe"
		${EndIf}
		${If} ${FileExists} "$EXEDIR\App\PeaZip\res\zstd\zstd32.exe"
			Rename "$EXEDIR\App\PeaZip\res\zstd\zstd.exe" "$EXEDIR\App\PeaZip\res\zstd\zstd64.exe"
			Rename "$EXEDIR\App\PeaZip\res\zstd\zstd32.exe" "$EXEDIR\App\PeaZip\res\zstd\zstd.exe"
		${EndIf}
    ${EndIf}
!macroend
