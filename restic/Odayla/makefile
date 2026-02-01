MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
#REPO := /misc/removable/restic
#REPO := /misc/removable2/restic
UUID1 := c4cf0644-9e83-470c-a96e-1c70af6fb45e
UUID2 := d93aa829-1f61-41fd-9b12-89f91790575b

HOSTS := root@Malkion.local
REMOTE_REPO1 := sftp:root@Malkion.local:/misc/removable/restic
REMOTE_REPO2 := sftp:root@Malkion.local:/misc/removable2/restic

# UUIDとREPOの対応を検索してREMOTE_REPOに代入
REMOTE_REPO := $(shell \
  for h in $(HOSTS); do \
		echo "Checking $$h..." >&2; \
    if ssh $$h test -e /dev/disk/by-uuid/$(UUID2); then \
      echo $(REMOTE_REPO2); exit 0; \
    elif ssh $$h test -e /dev/disk/by-uuid/$(UUID1); then \
      echo $(REMOTE_REPO1); exit 0; \
    fi; \
  done; \
  echo NONE; \
)

ifeq ($(REPO),NONE)
  $(error Neither UUID1 ($(UUID1)) nor UUID2 ($(UUID2)) found on any of $(HOSTS))
endif


# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

#.PHONY: backup compare check dryrun list ls stats

init: ## make restic repositry
	sudo /usr/bin/restic -p passwd.txt init -r ${REPO} --verbose

backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
		--exclude-caches \
		--exclude-file Odayla-exclude.list \
	 	--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup  \
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
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose check --read-data

repair-index: ## repair index
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose repair index --read-data

repair-pack: ## repair pack
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose repair pack --read-data

forget: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose forget \
		--prune \
		--keep-last 5 \
		--keep-daily 5

forget-dryrun: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose forget \
		--prune \
		--keep-last 5 \
		--keep-daily 5 \
		--dry-run

# snapshotsとかindexとかのリストが取れるが、何に使うのかいまいちわからないので
# 必要になるまでコメントにしておく
#list: ## get list of backups
#	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose list

ls: ## get list of latest backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose ls latest

mount: ## mount filesystem /mnt
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose mount /mnt

prune: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose prune

prune-dryrun: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose prune --dry-run

snapshots: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose snapshots

show: ## get list of backups by host. Need to add `host=Odayla`
	@if [ "${host}" = "hyperion" ]; then \
		sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} snapshots --host Odayla -c --tag hyperion; \
	else \
		sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} snapshots --host ${host} -c; \
	fi

stats: ## stats
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO}  --verbose stats

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
