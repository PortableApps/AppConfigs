!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "3.2.0.0" $R0
		${If} $R0 == 2
			;Coming from older version, handle .db file misplacement
			
			;Check for duplicate name
			${If} ${FileExists} "$INSTDIR\Data\cintanotes.db"
			${AndIf} ${FileExists} "$INSTDIR\App\CintaNotes\cintanotes.db"
				Rename "$INSTDIR\Data\cintanotes.db" "$INSTDIR\Data\cintanotes_other.db"
				Rename "$INSTDIR\App\CintaNotes\cintanotes.db" "$INSTDIR\Data\cintanotes.db"
			${EndIf}
			
			;Check for duplicate backup
			${If} ${FileExists} "$INSTDIR\Data\backup\*.*"
			${AndIf} ${FileExists} "$INSTDIR\App\CintaNotes\backup\*.*"
				Rename "$INSTDIR\Data\backup" "$INSTDIR\Data\backup-other"
				Rename "$INSTDIR\App\CintaNotes\backup" "$INSTDIR\Data\backup"
			${EndIf}
			
			;Check for failed close, move files back
			${If} ${FileExists} "$INSTDIR\Data\PortableApps.comLauncherRuntimeData-CintaNotesPortable.ini"
				Rename "$INSTDIR\App\CintaNotes\backup" "$INSTDIR\Data\backup"
				Rename "$INSTDIR\App\CintaNotes\cintanotes.settings" "$INSTDIR\Data\cintanotes.settings"
				${IfNot} ${FileExists} "$INSTDIR\Data\cintanotes.db"
				${AndIf} ${FileExists} "$INSTDIR\App\CintaNotes\cintanotes.db"
					Rename "$INSTDIR\App\CintaNotes\cintanotes.db" "$INSTDIR\Data\cintanotes.db"
				${EndIf}
				Delete "$INSTDIR\Data\PortableApps.comLauncherRuntimeData-CintaNotesPortable.ini"
			${EndIf}
			
			;Check for stray db files
			${If} ${FileExists} "$INSTDIR\App\CintaNotes\*.db"
				;Some db files are misplaced
				${If} ${FileExists} "$INSTDIR\Data\*.db"
					;Potential collisions, move
					CreateDirectory "$INSTDIR\Data\AdditionalDatabases"
					CopyFiles /SILENT "$INSTDIR\Data\*.db" "$INSTDIR\Data\AdditionalDatabases"
					Delete "$INSTDIR\Data\*.db"
					CopyFiles /SILENT "$INSTDIR\App\CintaNotes\*.db" "$INSTDIR\Data"
					Delete  "$INSTDIR\App\CintaNotes\*.db"
				${Else}
					CopyFiles /SILENT "$INSTDIR\App\CintaNotes\*.db" "$INSTDIR\Data"
					Delete  "$INSTDIR\App\CintaNotes\*.db"
				${EndIf}
			${EndIf}
		${EndIf}
	${EndIf}
!macroend