X11-appdefaults ?= ${confdir}/X11/app-defaults

dpi ?= ${Xft-auto-dpi}
Xft-auto-dpi != xdpyinfo | sed -n /resolution:/s/.\*x//p | cut -d\  -f1

X11-static-classes  := X11/XTerm
X11-static-files    := ${X11-static-classes}
X11-dynamic-classes := X11/Xft
X11-dynamic-files   := X11/.Xdefaults ${X11-dynamic-classes}
X11-classes         := ${X11-static-classes} ${X11-dynamic-classes}
X11-files           := ${X11-static-files} ${X11-dynamic-files}

.PHONY: X11 X11/clean

X11: ${X11-files}

X11/.Xdefaults: ${X11-classes}
	> $@;\
	for f in ${X11-classes}; do\
		echo -E "#include \"${X11-appdefaults}/$${f##*/}\"" >> $@;\
	done

X11/Xft:
	echo -E 'Xft.dpi:${dpi}' > $@

X11/clean:
	rm -f ${X11-dynamic-files}
