.DEFAULT_GOAL := help

FORMULA_FILE := Formula/nouli.rb
FORMULA := nouli-ai/tap/nouli
export HOMEBREW_NO_AUTO_UPDATE := 1
export HOMEBREW_NO_ANALYTICS := 1
export HOMEBREW_NO_INSTALL_CLEANUP := 1
export PYTHONDONTWRITEBYTECODE := 1

.PHONY: help fmt link-tap lint test check update protect-main

help:
	@echo 'make fmt            Format the formula'
	@echo 'make link-tap       Register this checkout as the local nouli-ai/tap'
	@echo 'make check          Check formula style, audit, workflows, scripts, and updater tests'
	@echo 'make update         Update the Nouli formula (requires gh auth)'
	@echo '                    Set RELEASE_TAG=vX.Y.Z to select a published stable release'
	@echo 'make protect-main   Configure maintainer/bot PR rules (requires APP_SLUG and admin auth)'

fmt:
	brew style --fix $(FORMULA_FILE)

link-tap:
	bash scripts/link-tap.sh

lint: link-tap
	brew style $(FORMULA_FILE)
	brew audit --formula $(FORMULA)
	actionlint
	shellcheck scripts/*.sh

test:
	python3 -m unittest discover -s tests -v

check: lint test

update:
	python3 -m scripts.update_formula

protect-main:
	APP_SLUG="$(APP_SLUG)" python3 scripts/protect_main.py
