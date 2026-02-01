MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
REPO := /misc/removable/restic
UUID1 := c4cf0644-9e83-470c-a96e-1c70af6fb45e
UUID2 := d93aa829-1f61-41fd-9b12-89f91790575b
HOSTS := root@Malkion.local
#REMOTE_REPO1 := sftp:root@Odayla.local:/misc/removable/restic
#REMOTE_REPO2 := sftp:root@Odayla.local:/misc/removable2/restic
#HOSTS := host1 host2 host3

UUID1_EXISTS := $(shell ls /dev/disk/by-uuid/ | grep -q $(UUID1) && echo yes || echo no)
UUID2_EXISTS := $(shell ls /dev/disk/by-uuid/ | grep -q $(UUID2) && echo yes || echo no)

ifeq ($(UUID1_EXISTS),yes)
	REPO := /misc/removable/restic
else ifeq ($(UUID2_EXISTS),yes)
	REPO := /misc/removable2/restic
else
  $(error Disk not found)
endif

HOSTS := root@Odayla.local

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
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file Malkion-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/;

backup-native: ## backup command
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
		--exclude-caches \
	 	--exclude-file Malkion-exclude.list \
		--files-from dict.list \
		--files-from etc.list \
		--files-from var.list \
	 	/home/ \
		/root/

backup-dryrun: ## Dry run for backup
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose backup \
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
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose check --read-data


## outdateなパックアップを消去 ##
forget: ## remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune
		--keep-last 7

forget-dryrun: ## dry run for remove snapshots
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose forget \
		--prune \
		--keep-last 7 \
		--dry-run

#list: ## get list of backups
#	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose list

ls: ## get list of backups
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose ls latest

## 取り出す ##
mount: ## mount filesystem /mnt
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose mount /mnt

## リポジトリのメンテナンス ##
prune: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose prune

prune-dryrun: ## prune data
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose prune --dry-run

## スナップショット一覧 ##
snapshots-all: ## get list of backups (全部)
	sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} --verbose snapshots

show: ## get list of backups by host. Need to add `host=Odayla`
	@if [ "${host}" = "hyperion" ]; then \
		sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} snapshots --host Odayla -c --tag hyperion; \
	else \
		sudo /usr/bin/restic --password-file passwd.txt -r ${REPO} snapshots --host ${host} -c; \
	fi


## 統計情報 ##
stats: ## stats
	sudo /usr/bin/restic --password-file passwd.txt  -r ${REPO} --verbose stats

#	help: ## Print this help
#		@echo 'Usage: make  [target]'
#		@echo ''
#		@echo 'Targets:'
#		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
help:
	@grep -E -e '^[a-zA-Z_-]+:.*?## .*$$' -e '^## .* ##$$' $(MAKEFILE_LIST) \
		| ../../help.awk | less -R
