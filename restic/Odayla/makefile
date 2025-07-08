MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
REPO := /misc/removable/restic

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

#.PHONY: backup compare check dryrun list ls stats

backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-file Odayla-exclude.list \
	 	--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup  \
		--dry-run -vv \
		--exclude-file Odayla-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

compare: ## compare now

check: ## check backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose check --read-data

forget: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune \
		--keep-daily 14

forget-dryrun: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune \
		--keep-daily 14 \
		--dry-run

# snapshotsとかindexとかのリストが取れるが、何に使うのかいまいちわからないので
# 必要になるまでコメントにしておく
#list: ## get list of backups
#	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose list

ls: ## get list of latest backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose ls latest

mount: ## mount filesystem /mnt
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose mount /mnt

prune: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose prune

prune-dryrun: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose prune --dry-run

snapshots: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose snapshots

stats: ## statss
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO}  --verbose stats

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
