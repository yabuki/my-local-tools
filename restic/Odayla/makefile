MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
#REPO := /misc/removable/restic
#REPO := /misc/removable2/restic
UUID1 := c4cf0644-9e83-470c-a96e-1c70af6fb45e
UUID2 := d93aa829-1f61-41fd-9b12-89f91790575b

UUID1_EXISTS := $(shell ls /dev/disk/by-uuid/ | grep -q $(UUID1) && echo yes || echo no)
UUID2_EXISTS := $(shell ls /dev/disk/by-uuid/ | grep -q $(UUID2) && echo yes || echo no)

ifeq ($(UUID1_EXISTS),yes)
	REPO := /misc/removable/restic
else ifeq ($(UUID2_EXISTS),yes)
	REPO := /misc/removable2/restic
else
  $(error Disk not found)
endif


# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

#.PHONY: backup compare check dryrun list ls stats

init: ## make restic repositry
	sudo /usr/bin/restic -p passwd.txt init -r ${REPO} --verbose

backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-caches \
		--exclude-file Odayla-exclude.list \
	 	--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup  \
		--dry-run -vv \
		--exclude-caches \
		--exclude-file Odayla-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

compare: ## compare now

check: ## check backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose check --read-data

repair: ## repair index
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose repair index --read-data

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
