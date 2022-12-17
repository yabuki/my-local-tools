MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
DEST := /misc/removable/Odayla
EXCLUDEFILE := ./Odayla-exclude.list
EXECMACHINE := Odayla

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			--print-statistics \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			/home/ \
			$(DEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi

bk: ## force backup
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			-b \
			--print-statistics \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			/home/ \
			$(DEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi

compare: ## compare now
	if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			--compare \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			/home/ \
			$(DEST)/home/ ; \
			echo "exit code $$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi
	echo "exit code $$?"

verify: ## verify backup
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			--verify \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			$(DEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi

list: ## get list of backups
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			-l \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			$(DEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi

remove-older-than: ## remove old backup sets
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ -d '$(DEST)' ]; then \
			/usr/bin/rdiff-backup \
			--force \
			--remove-older-than 1M \
			--print-statistics \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			$(DEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(DEST)" | mail -s "Is $(DEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you be in $(EXECMACHINE)?"; \
	fi

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
