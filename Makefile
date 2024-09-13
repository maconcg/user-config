default: all

.include "overrides.mk"

confdir ?= ${HOME}/.config

.include "X11/include.mk"

.PHONY: default install uninstall clean

all: X11

install: X11/install

uninstall: X11/uninstall

clean: X11/clean
