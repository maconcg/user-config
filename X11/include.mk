LC_CTYPE      := en_US.UTF-8
shebang       := \#!/bin/sh -
X11-dest      := ${confdir}/X11
xsession-dest := ${HOME}/.xsession

.include "X11/Xdefaults/include.mk"
.include "X11/cwmrc/include.mk"

.PHONY: X11 X11/clean X11/install X11/install-xsession X11/uninstall \
        X11/uninstall-xsession

X11: ${Xdefaults-files} ${cwmrc-files} X11/xsession

X11/clean: X11/Xdefaults/clean X11/cwmrc/clean
	rm -f X11/xsession

X11/install: X11/install-xsession X11/Xdefaults/install X11/cwmrc/install

X11/uninstall: X11/Xdefaults/uninstall X11/cwmrc/uninstall \
               X11/uninstall-xsession
	if [[ -d ${X11-dest} ]]; then\
		rmdir ${X11-dest} || :;\
	fi

X11/xsession: X11/xsession.in
	sed -e "s|@SETXKBMAP@|$$(realpath `command -v setxkbmap`)|"\
		-e "s|@XMODMAP@|$$(realpath `command -v xmodmap`)|"\
		-e "s|@XSET@|$$(realpath `command -v xset`)|"\
		-e "s|@XIDLE@|$$(realpath `command -v xidle`)|"\
		-e "s|@XLOCK@|$$(realpath `command -v xlock`)|"\
		-e "s|@CWM@|$$(realpath `command -v cwm`)|"\
                -e 's|@LC_CTYPE@|${LC_CTYPE}|'\
		-e 's|@XSESSION_DIR@|${X11-dest}/xsession|'\
		-e 's|@CWMRC_DEST@|${cwmrc-dest}|'\
		-e 's|${HOME}|~|'\
		X11/xsession.in > $@

X11/install-xsession: X11/xsession
	[[ -f ${xsession-dest} && -s ${xsession-dest} ]] ||\
		echo -E '${shebang}' > ${xsession-dest}
	libexec/manage-block -u -f X11/xsession -t ${xsession-dest} \
		-c '#' -n MANAGED

X11/uninstall-xsession:
	libexec/manage-block -d -t ${xsession-dest} -c '#' -n MANAGED
	if [[ -f ${xsession-dest} ]]; then\
		if [[ "$$(<${xsession-dest})" == '${shebang}' ]]; then\
			rm ${xsession-dest};\
		fi;\
	fi
