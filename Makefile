.PHONY: init build inspect lint
.DEFAULT_GOAL := help

NAMESPACE := tomdewildt
NAME := raspberry-pi-images

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

help: ## Show this help
	@echo "${NAMESPACE}/${NAME}"
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | \
	fgrep -v fgrep | sed -e 's/## */##/' | column -t -s##

##

init: ## Initialize the environment
	packer init config.pkr.hcl

##

build: ## Build image
	packer build ./templates/${template}.pkr.hcl

##

inspect: ## Run inspect
	packer inspect ./templates/${template}.pkr.hcl

##

lint: ## Run lint
	packer validate ./templates/${template}.pkr.hcl
