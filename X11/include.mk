X11-dest := ${confdir}/X11

.include "X11/Xdefaults/include.mk"
.include "X11/cwmrc/include.mk"

.PHONY: X11 X11/clean X11/install X11/uninstall

X11: ${Xdefaults-files} ${cwmrc-files}

X11/clean: X11/Xdefaults/clean X11/cwmrc/clean

X11/install: X11/Xdefaults/install X11/cwmrc/install

X11/uninstall: X11/Xdefaults/uninstall X11/cwmrc/uninstall
	if [[ -d ${X11-dest} ]]; then rmdir ${X11-dest}; fi
