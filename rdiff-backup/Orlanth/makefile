MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
USER := yabuki
TARGET := odayla.local
EXECMACHINE := Orlanth
DEST := /misc/removable/Orlanth
REMOTEDEST := yabuki@odayla.local::/misc/removable/Orlanth
EXCLUDEFILE := ./Orlanth-exclude.list

# all targets are phony
.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')


#.PHONY: backup bk compare verify list

backup: ## backup command
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
			/usr/bin/rdiff-backup --new backup \
			--print-statistics \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			/home/ \
			$(REMOTEDEST)/home/ ; \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

bk: ## force backup
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
		/usr/bin/rdiff-backup --new backup \
		--force \
		--print-statistics \
		--exclude-globbing-filelist '$(EXCLUDEFILE)' \
		/home/ \
		$(REMOTEDEST)/home/ ; \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

compare: ## compare now
	if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
			/usr/bin/rdiff-backup --new \
			compare \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			/home/ \
			$(REMOTEDEST)/home/ ; \
			echo "exit code \$$?" \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

verify: ## verify backup
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
			/usr/bin/rdiff-backup --new \
			verify \
			$(REMOTEDEST)/home/ ; \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

list: ## get list of backups
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
			/usr/bin/rdiff-backup --new \
			list increments \
			$(REMOTEDEST)/home/ ; \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

remove-older-than: ## remove old backup sets
	@if [ `hostname` == $(EXECMACHINE) ]; then \
		if [ $$(ssh $(USER)@$(TARGET) "[ -d $(DEST) ];echo \$$?") -eq 0 ]; then \
			/usr/bin/rdiff-backup --new \
			remove \
			--force \
			--remove-older-than 1M \
			--print-statistics \
			--exclude-globbing-filelist '$(EXCLUDEFILE)' \
			$(REMOTEDEST)/home/ ; \
		else \
			echo "I couldn't get $(REMOTEDEST)" | mail -s "Is $(REMOTEDEST) active?" yabuki ; \
		fi \
	else \
		echo "Are you in $(EXECMACHINE)?"; \
	fi

help: ## Print this help
	@echo 'Usage: make  [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
