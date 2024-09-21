# SPDX-License-Identifier: Apache-2.0
# Copyright © 2024 Macon Gambill

X11-app-defaults ?= ${X11-dest}/app-defaults
Xdefaults-dest   ?= ${HOME}/.Xdefaults
dpi              ?= ${Xft-auto-dpi}
Xft-auto-dpi     != xdpyinfo | sed -n /resolution:/s/.\*x//p | cut -d\  -f1

Xdefaults-static-classes  := X11/Xdefaults/XTerm
Xdefaults-static-files    := ${Xdefaults-static-classes}
Xdefaults-dynamic-classes := X11/Xdefaults/Xft
Xdefaults-dynamic-files   := X11/Xdefaults/Xdefaults ${Xdefaults-dynamic-classes}
Xdefaults-classes := ${Xdefaults-static-classes} ${Xdefaults-dynamic-classes}
Xdefaults-files           := ${Xdefaults-static-files} ${Xdefaults-dynamic-files}

X11/Xdefaults/Xdefaults: ${Xdefaults-classes}
	for f in ${Xdefaults-classes}; do\
		echo -E "#include \"${X11-app-defaults}/$${f##*/}\"";\
	done | sort -u > $@

X11/Xdefaults/Xft:
	echo -E 'Xft.dpi:${dpi}' > $@

X11/Xdefaults/clean:
	rm -f ${Xdefaults-dynamic-files}

X11/Xdefaults/install: X11/Xdefaults/install-classes \
                       X11/Xdefaults/install-Xdefaults

X11/Xdefaults/install-Xdefaults: X11/Xdefaults/Xdefaults
	libexec/manage-block -u -f X11/Xdefaults/Xdefaults -t ${Xdefaults-dest} \
		-c '!' -n INCLUDE

X11/Xdefaults/install-classes: ${Xdefaults-classes}
	test -d ${X11-app-defaults} || mkdir -p ${X11-app-defaults}
	install -m0644 -p ${Xdefaults-classes} ${X11-app-defaults}

X11/Xdefaults/uninstall:
	libexec/manage-block -d -t ${Xdefaults-dest} -c '!' -n INCLUDE
	rm -f $$(for c in ${Xdefaults-classes}; do\
			echo -E "${X11-app-defaults}/$${c##*/}";\
		done) &&\
	if [[ -d ${X11-app-defaults} ]]; then rmdir ${X11-app-defaults}; fi
