# SPDX-License-Identifier: Apache-2.0
# Copyright © 2024 Macon Gambill

.PHONY: X11/cwmrc X11/cwmrc/clean X11/cwmrc/install X11/cwmrc/uninstall

cwmrc-default-header := \# -*- mode: conf-space; -*-
cwmrc-static-files   := X11/cwmrc/local X11/cwmrc/misc X11/cwmrc/bindings
cwmrc-files          := ${cwmrc-static-files} X11/cwmrc/cwmrc
cwmrc-dest           := ${X11-dest}/cwmrc
child-cwmrc-dest     := ${X11-dest}/child-cwmrc

X11/cwmrc: ${cwmrc-files}

X11/cwmrc/cwmrc: ${cwmrc-static-files}
	echo -E '${cwmrc-default-header}' > $@
	for f in ${cwmrc-static-files}; do\
		if [[ $${f##*/} == local && ! -f "$$f" ]]; then continue; fi;\
		typeset -u upper=$${f##*/} &&\
		libexec/manage-block -u -f "$$f" -t $@ -c '#' -n $$upper;\
	done

X11/cwmrc/local: .OPTIONAL

X11/cwmrc/clean:
	rm -f X11/cwmrc/cwmrc

X11/cwmrc/install: X11/cwmrc/install-cwmrc X11/cwmrc/install-child-cwmrc

X11/cwmrc/install-cwmrc: X11/cwmrc/cwmrc
	[[ -d ${X11-dest} ]] || mkdir -p ${X11-dest}
	[[ -f ${cwmrc-dest} && -s ${cwmrc-dest} ]] ||\
		echo -E '${cwmrc-default-header}' > ${cwmrc-dest} &&\
	readonly tmp=$$(mktemp) &&\
	trap "rm $$tmp" ERR EXIT &&\
	for f in ${cwmrc-static-files}; do\
		if [[ $${f##*/} == local && ! -f "$$f" ]]; then continue; fi;\
		typeset -u upper=$${f##*/} &&\
		libexec/manage-block -e -f X11/cwmrc/cwmrc -c '#' -n $$upper;\
	done > $$tmp &&\
	libexec/manage-block -u -f $$tmp -t ${cwmrc-dest} -c '#' -n MANAGED

X11/cwmrc/install-child-cwmrc: X11/cwmrc/child-cwmrc
	[[ -d ${X11-dest} ]] || mkdir -p ${X11-dest}
	[[ -f ${child-cwmrc-dest} && -s ${child-cwmrc-dest} ]] ||\
		echo -E '${cwmrc-default-header}' > ${child-cwmrc-dest} &&\
	libexec/manage-block -u -f X11/cwmrc/child-cwmrc \
		-t ${child-cwmrc-dest} -c '#' -n MANAGED

X11/cwmrc/uninstall:
	libexec/manage-block -d -t ${cwmrc-dest} -c '#' -n MANAGED
	libexec/manage-block -d -t ${child-cwmrc-dest} -c '#' -n MANAGED
	for f in ${cwmrc-dest} ${child-cwmrc-dest}; do\
		if [[ -f $$f ]]; then\
			if [[ "$$(<$$f)" == '${cwmrc-default-header}' ]]; then\
				rm $$f;\
			fi;\
		fi;\
	done
