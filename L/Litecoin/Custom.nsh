${SegmentFile}
Var CustomFirstRunDone
Var CustomPrunedModeNotSeleted

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\LitecoinPortableSettings.ini" "LitecoinPortableSettings" "FirstRunDone"
	${If} $0 != true
		ClearErrors
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `SIZE WARNING: Litecoin Portable will download its blockchain and take up 4GB (pruned) to 52GB+ (full) of space on your device. You will be allowed to select which. It should not be used on slower flash-based devices.$\r$\n$\r$\nAre you sure you'd like to use Litecoin Portable in this location?` IDYES CustomSelectPruned IDNO CustomGotoNoStart
		
		CustomSelectPruned:
			IFFileExists "$EXEDIR\Data\Litecoin\blocks\*.*" CustomGotoStart
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `Litecoin Portable can operate in pruned mode, where it will keep the last 2.2GB of the blockchain and prune older blocks on an ongoing basis. This will take up about 4.4GB of space on your device instead of 52GB+ of the full blockchain.$\r$\n$\r$\nWould you like to use Litecoin Portable in pruned mode?` IDYES CustomAskDownload IDNO CustomPrunedNotSeleted
			
		CustomAskDownload:
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `PortableApps.com packages a recent pruned blockchain as a digitally signed self-extracting archive to help you get up and running faster.$\r$\n$\r$\nWould you like to download the recent blockchain?` IDYES CustomGotoDownload IDNO CustomGotoStart
		
		CustomGotoDownload:
			CreateDirectory "$EXEDIR\Data"
			CreateDirectory "$EXEDIR\Data\Litecoin"
			CreateDirectory "$EXEDIR\Data\settings"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\Litecoin\Litecoin.conf" "$EXEDIR\Data\Litecoin"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\Litecoin.reg" "$EXEDIR\Data\settings"
			WriteINIStr "$EXEDIR\Data\settings\LitecoinPortableSettings.ini" "LitecoinPortableSettings" "FirstRunDone" "true"
			MessageBox MB_OK|MB_ICONINFORMATION `A browser window will now open to download the Litecoin blockchain from blockchains.download, a PortableApps.com project. Litecoin Portable has been configured in Pruned mode and will now close. Once you extract the blockchain files to your LitecoinPortable\Data\Litecoin directory, you can start Litecoin Portable again and it will pick up where you left off.` IDOK CustomDownloadBlockchain
			
		CustomDownloadBlockchain:
			ExecShell "open" "https://portableapps.com/go/LitecoinBlockchain" SW_SHOWNORMAL
			Goto CustomGotoNoStart

		CustomPrunedNotSeleted:
			StrCpy $CustomPrunedModeNotSeleted true
		
		CustomGotoStart:
			StrCpy $CustomFirstRunDone true
			Goto CustomGotoEnd
			
		CustomGotoNoStart:
			Abort
			
		CustomGotoEnd:
	${EndIf}
!macroend

${SegmentPreExecPrimary}
	${If} $CustomPrunedModeNotSeleted == true
		Delete "$EXEDIR\Data\Litecoin\litecoin.conf"
	${EndIf}
	${If} $CustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\LitecoinPortableSettings.ini" "LitecoinPortableSettings" "FirstRunDone" "true"
	${EndIf}
!macroend