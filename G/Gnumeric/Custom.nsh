${SegmentFile}

${Segment.OnInit}
	Delete "$EXEDIR\App\Gnumeric\lib\gdk-pixbuf-2.0\2.10.0\loaders.cache"
	Delete "$EXEDIR\App\Gnumeric\lib\pango\1.8.0\modules.cache"
	CopyFiles "$EXEDIR\App\Gnumeric\lib\gdk-pixbuf-2.0\2.10.0\loaders.cache.default" "$EXEDIR\App\Gnumeric\lib\gdk-pixbuf-2.0"
	Rename "$EXEDIR\App\Gnumeric\lib\gdk-pixbuf-2.0\loaders.cache.default" "$EXEDIR\App\Gnumeric\lib\gdk-pixbuf-2.0\2.10.0\loaders.cache"
	CopyFiles "$EXEDIR\App\Gnumeric\lib\pango\1.8.0\modules.cache.default" "$EXEDIR\App\Gnumeric\lib\pango"
	Rename "$EXEDIR\App\Gnumeric\lib\pango\modules.cache.default" "$EXEDIR\App\Gnumeric\lib\pango\1.8.0\modules.cache"
!macroend