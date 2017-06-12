DEPLOY_SYMLINK = /homewww/die-koma.org/beta/.content
DIRECTORY_ALPHA = /homewww/die-koma.org/beta/.alpha
DIRECTORY_BETA = /homewww/die-koma.org/beta/.beta

SHELL = /bin/bash
FILES = $(shell find * -maxdepth 1 | egrep -v "^(_site|Makefile)")

.PHONY: update

build: _site

_site: ${FILES}
	jekyll build

update:
	git pull

ifeq ($(shell readlink ${DEPLOY_SYMLINK}), ${DIRECTORY_ALPHA})
deploy: ${DIRECTORY_BETA}
else
deploy: ${DIRECTORY_ALPHA}
endif

${DIRECTORY_ALPHA} ${DIRECTORY_BETA}: ${FILES}
	mkdir -p "$@"
	jekyll build --destination "$@"
	ln -fns "$@" "${DEPLOY_SYMLINK}"
