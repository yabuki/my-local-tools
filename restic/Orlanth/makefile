MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
REPO := /misc/removable/restic
UUID1 := c4cf0644-9e83-470c-a96e-1c70af6fb45e
UUID2 := d93aa829-1f61-41fd-9b12-89f91790575b
REMOTE_REPO1 := sftp:root@Odayla.local:/misc/removable/restic
REMOTE_REPO2 := sftp:root@Odayla.local:/misc/removable2/restic
#HOSTS := host1 host2 host3
HOSTS := root@Odayla.local

# UUIDとREPOの対応を検索してREMOTE_REPOに代入
REMOTE_REPO := $(shell \
  for h in $(HOSTS); do \
		echo "Checking $$h..." >&2; \
    if ssh $$h test -e /dev/disk/by-uuid/$(UUID1); then \
      echo $(REMOTE_REPO1); exit 0; \
    elif ssh $$h test -e /dev/disk/by-uuid/$(UUID2); then \
      echo $(REMOTE_REPO2); exit 0; \
    fi; \
  done; \
  echo NONE; \
)

ifeq ($(REPO),NONE)
  $(error Neither UUID1 ($(UUID1)) nor UUID2 ($(UUID2)) found on any of $(HOSTS))
endif

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

# .env を読み込んでシェル変数にする
#include .env
#export $(shell sed 's/=.*//' .env)

#.PHONY: backup bk compare verify list

## バックアップ ##
auto: ## backup command
	expect -d -c ' \
		spawn sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
			--exclude-caches \
			--exclude-file Orlanth-exclude.list \
			--files-from dict.list \
			--files-from etc.list \
			--files-from var.list \
			/home/ /root/;
		expect { \
	'yes/no' { send 'yes\r'; exp_continue } \
	-regex '.*password: ' { send '${RootPassWord}\n' } \
	}; \
	'

backup: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/;

backup-native: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run for backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REMOTE_REPO} --verbose backup \
		--dry-run \
		--exclude-caches \
		--exclude-file Orlanth-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
 		/home/ \
		/root/

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
