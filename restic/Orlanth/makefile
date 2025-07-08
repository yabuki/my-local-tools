MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
#REPO := /misc/removable/Orlanth
REPO := /misc/removable/restic
RESTIC_PASSWORD := orlanth

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r sftp:root@Odayla.local:/${REPO} --verbose backup \
	 	--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-native: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
	 	--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run for backup
	sudo /usr/bin/restic --password-file passwd.txt -r sftp:root@Odayla.local:/${REPO} --verbose backup \
		--dry-run \
		--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
 		/home/ \
		/root/

compare: ## compare now

check: ## check backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose check --read-data

forget: ## remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune
		--keep-last 7

forget-dryrun: ## dry run for remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune \
		--keep-last 7 \
		--dry-run

list: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose list

ls: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose ls latest

mount: ## mount filesystem /mnt
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose mount /mnt

snapshots: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r sftp:root@Odayla.local:/${REPO} --verbose snapshots --host Orlanth

stats: ## statss
	sudo /usr/bin/restic --password-file passwd.txt  -r ${REPO} --verbose stats

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
