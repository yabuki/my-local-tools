MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
DEST := /misc/removable/Odayla
EXCLUDEFILE := ./Odayla-exclude.list

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(DEST)/home/ ; \
	else \
	echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
	fi

bk: ## force backup
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	-b \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(DEST)/home/ ; \
	else \
	echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
	fi

compare: ## compare now
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	--compare \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	/home/ \
	$(DEST)/home/ ; \
	fi

verify: ## verify backup
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	--verify \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(DEST)/home/ ; \
	fi

list: ## get list of backups
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	-l \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(DEST)/home/ ; \
	fi

remove-older-than: ## remove old backup sets
	if [ -d '$(DEST)' ]; then \
	sudo /usr/bin/rdiff-backup \
	--force \
	--remove-older-than 1M \
	--print-statistics \
	--exclude-globbing-filelist '$(EXCLUDEFILE)' \
	$(DEST)/home/ ; \
	fi

help: ## Print this help
	@echo 'Usage: make -f Odayla.mk [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
