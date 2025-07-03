MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
REPO := /misc/removable/Orlanth
RESTIC_PASSWORD := orlanth

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	sudo @env /usr/bin/restic -r ${REPO} --verbose backup --exclude-file Orlanth-exclude.list /home/

compare: ## compare now

check: ## check backup
	sudo /usr/bin/restic -r ${REPO} --verbose check --read-data

list: ## get list of backups
	sudo /usr/bin/restic -r ${REPO} --verbose list

ls: ## get list of backups
	sudo /usr/bin/restic -r ${REPO} --verbose ls latest

stats: ## statss
	sudo /usr/bin/restic -r ${REPO} --verbose stats

remove-older-than: ## remove old backup sets

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
