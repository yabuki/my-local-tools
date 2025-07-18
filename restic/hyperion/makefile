MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
#REPO := /misc/removable/Orlanth
REPO := /misc/removable/restic
#REMOTE_REPO := sftp:root@Odayla.local:/misc/removable/restic
REMOTE_REPO := /misc/removable/restic

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

## sshfs ##
open-connection: ## open connection
	sshfs yabuki@hyperion.netfort.gr.jp:/home/yabuki ./mnt -o default_permissions,allow_other,idmap=user

close-connection: ## close connection
	fusermount3 -u ./mnt

## バックアップ ##
backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file hyperion-exclude.list \
	 	./mnt/

backup-native: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file hyperion-exclude.list \
		./mnt/

backup-dryrun: ## Dry run for backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
		--dry-run \
		--exclude-caches \
		--exclude-file hyperion-exclude.list \
		./mnt/

compare: ## compare now

## リポジトリのチェック ##
check: ## check backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose check --read-data


## outdateなパックアップを消去 ##
forget: ## remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose forget \
		--prune
		--keep-last 7

forget-dryrun: ## dry run for remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose forget \
		--prune \
		--keep-last 7 \
		--dry-run

#list: ## get list of backups
#	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose list

ls: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose ls latest

## 取り出す ##
mount: ## mount filesystem /mnt
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose mount /mnt

## リポジトリのメンテナンス ##
prune: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose prune

prune-dryrun: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose prune --dry-run

## スナップショット一覧 ##
snapshots: ## get list of backups(for Orlanth)
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose snapshots --host Orlanth

snapshots-all: ## get list of backups (全部)
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose snapshots

## 統計情報 ##
stats: ## stats
	sudo /usr/bin/restic --password-file passwd.txt  -r ${REMOTE_REPO} --verbose stats

#	help: ## Print this help
#		@echo 'Usage: make  [target]'
#		@echo ''
#		@echo 'Targets:'
#		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
help:
	@grep -E -e '^[a-zA-Z_-]+:.*?## .*$$' -e '^## .* ##$$' $(MAKEFILE_LIST) \
		| ../../help.awk | less -R
