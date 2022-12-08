MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
USER := yabuki
TARGET := odayla.local
DEST := /misc/removable/Orlanth
REMOTEDEST := yabuki@odayla.local::/misc/removable/Orlanth
#EXCLUDEFILE := ./Orlanth-exclude.list
EXCLUDEFILE := /home/yabuki/scm/git/my-local-tools/rdiff-backup/Orlanth/Orlanth-exclude.list

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	/usr/bin/rdiff-backup \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(REMOTEDEST)/home/ ; \
	else \
	echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
	fi

bk: ## force backup
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	sudo /usr/bin/rdiff-backup \
	-b \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(REMOTEDEST)/home/ ; \
	else \
	echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
	fi

compare: ## compare now
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	sudo /usr/bin/rdiff-backup \
	--compare \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(REMOTEDEST)/home/ ; \
	fi

verify: ## verify backup
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	sudo /usr/bin/rdiff-backup \
	--verify \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(REMOTEDEST)/home/ ; \
	fi

list: ## get list of backups
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	sudo /usr/bin/rdiff-backup \
	-l \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(REMOTEDEST)/home/ ; \
	fi

remove-older-than: ## remove old backup sets
	if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
	sudo /usr/bin/rdiff-backup \
	--force \
	--remove-older-than 1M \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(REMOTEDEST)/home/ ; \
	fi

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
