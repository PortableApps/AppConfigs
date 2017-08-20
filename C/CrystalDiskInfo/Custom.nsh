${SegmentFile}

${SegmentInit}
    ${If} $Bits = 64
		${If} ${FileExists} "$EXEDIR\App\CrystalDiskInfo\DiskInfo64.exe"
			Rename "$EXEDIR\App\CrystalDiskInfo\DiskInfo.exe" "$EXEDIR\App\CrystalDiskInfo\DiskInfo32.exe"
			Rename "$EXEDIR\App\CrystalDiskInfo\DiskInfo64.exe" "$EXEDIR\App\CrystalDiskInfo\DiskInfo.exe"
		${EndIf}
	${Else}
		${If} ${FileExists} "$EXEDIR\App\CrystalDiskInfo\DiskInfo32.exe"
			Rename "$EXEDIR\App\CrystalDiskInfo\DiskInfo.exe" "$EXEDIR\App\CrystalDiskInfo\DiskInfo64.exe"
			Rename "$EXEDIR\App\CrystalDiskInfo\DiskInfo32.exe" "$EXEDIR\App\CrystalDiskInfo\DiskInfo.exe"
		${EndIf}
    ${EndIf}
!macroend
