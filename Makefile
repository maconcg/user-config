.include "overrides.mk"

confdir ?= ${HOME}/.config

.include "X11/include.mk"

.PHONY: clean default

default: X11

clean: X11/clean
