MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
USER := yabuki
TARGET := odayla.local
EXECMACHINE := Odayla
DEST := /misc/removable/Orlanth
REMOTEDEST := yabuki@odayla.local::/misc/removable/Orlanth
EXCLUDEFILE := ./Orlanth-exclude.list

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	sudo /usr/bin/restic -r /misc/removable/Odayla --verbose backup --exclude-file Odayla-exclude.list /home/

compare: ## compare now

verify: ## verify backup

list: ## get list of backups
	sudo /usr/bin/restic -r /misc/removable/Odayla --verbose list

ls: ## get list of backups
	sudo /usr/bin/restic -r /misc/removable/Odayla --verbose ls latest

stats: ## statss
	sudo /usr/bin/restic -r /misc/removable/Odayla --verbose stats

remove-older-than: ## remove old backup sets

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
