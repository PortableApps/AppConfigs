${SegmentFile}

${SegmentInit}
    ${If} ${FileExists} "$EXEDIR\gPodderPortable.ini"
		ReadINIStr $0 "$EXEDIR\gPodderPortable.ini" "gPodderPortable" "DownloadDirFullPath"
		${If} $0 != ""
			${SetEnvironmentVariablesPath} GPODDER_DOWNLOAD_DIR $0
		${EndIf}
		ReadINIStr $0 "$EXEDIR\gPodderPortable.ini" "gPodderPortable" "DownloadDirPartialPath"
		${If} $0 != ""
			${GetRoot} $EXEDIR $1
			${SetEnvironmentVariablesPath} GPODDER_DOWNLOAD_DIR $1\$0
		${EndIf} 
		ReadINIStr $0 "$EXEDIR\gPodderPortable.ini" "gPodderPortable" "DownloadDirPortableAppsRootPath"
		${If} $0 != ""
			${GetParent} $EXEDIR $1
			${GetParent} $1 $1
			${GetParent} $1 $1
			${SetEnvironmentVariablesPath} GPODDER_DOWNLOAD_DIR $1\$0
		${EndIf} 
    ${EndIf}
!macroend
