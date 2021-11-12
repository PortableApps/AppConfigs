${SegmentFile}
Var CustomFirstRunDone
Var CustomPrunedModeNotSeleted

${SegmentPrePrimary}
	ReadINIStr $0 "$EXEDIR\Data\settings\DogecoinPortableSettings.ini" "DogecoinPortableSettings" "FirstRunDone"
	${If} $0 != true
		ClearErrors
		MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `SIZE WARNING: Dogecoin Portable will download its blockchain and take up 4GB (pruned) to 52GB+ (full) of space on your device. You will be allowed to select which. It should not be used on slower flash-based devices.$\r$\n$\r$\nAre you sure you'd like to use Dogecoin Portable in this location?` IDYES CustomSelectPruned IDNO CustomGotoNoStart
		
		CustomSelectPruned:
			IFFileExists "$EXEDIR\Data\Dogecoin\blocks\*.*" CustomGotoStart
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `Dogecoin Portable can operate in pruned mode, where it will keep the last 2.2GB of the blockchain and prune older blocks on an ongoing basis. This will take up about 4.4GB of space on your device instead of 52GB+ of the full blockchain.$\r$\n$\r$\nWould you like to use Dogecoin Portable in pruned mode?` IDYES CustomAskDownload IDNO CustomPrunedNotSeleted
			
		CustomAskDownload:
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `PortableApps.com packages a recent pruned blockchain as a digitally signed self-extracting archive to help you get up and running faster.$\r$\n$\r$\nWould you like to download the recent blockchain?` IDYES CustomGotoDownload IDNO CustomGotoStart
		
		CustomGotoDownload:
			CreateDirectory "$EXEDIR\Data"
			CreateDirectory "$EXEDIR\Data\Dogecoin"
			CreateDirectory "$EXEDIR\Data\settings"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\Dogecoin\dogecoin.conf" "$EXEDIR\Data\Dogecoin"
			CopyFiles /SILENT "$EXEDIR\App\DefaultData\settings\Dogecoin.reg" "$EXEDIR\Data\settings"
			WriteINIStr "$EXEDIR\Data\settings\DogecoinPortableSettings.ini" "DogecoinPortableSettings" "FirstRunDone" "true"
			MessageBox MB_OK|MB_ICONINFORMATION `A browser window will now open to download the Dogecoin blockchain from blockchains.download, a PortableApps.com project. Dogecoin Portable has been configured in Pruned mode and will now close. Once you extract the blockchain files to your DogecoinPortable\Data\Dogecoin directory, you can start Dogecoin Portable again and it will pick up where you left off.` IDOK CustomDownloadBlockchain
			
		CustomDownloadBlockchain:
			ExecShell "open" "https://portableapps.com/go/DogecoinBlockchain" SW_SHOWNORMAL
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
		Delete "$EXEDIR\Data\Dogecoin\dogecoin.conf"
	${EndIf}
	${If} $CustomFirstRunDone == true
		WriteINIStr "$EXEDIR\Data\settings\DogecoinPortableSettings.ini" "DogecoinPortableSettings" "FirstRunDone" "true"
	${EndIf}
!macroend