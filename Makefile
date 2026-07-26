# Build targets for the adblock-dns Entware package.

PKG_NAME  := adblock-dns
PKG_DIR   := $(PKG_NAME)
OUT_DIR   := out
ETC_DIR   := $(PKG_DIR)/data/opt/etc/$(PKG_NAME)
VERSION   := $(shell sed -n 's/^Version: //p' $(PKG_DIR)/CONTROL/control)
PKG       := $(OUT_DIR)/$(PKG_NAME)_$(VERSION)_all.ipk
SOURCES   := $(shell find $(PKG_DIR) -type f)

.DEFAULT_GOAL := build

.PHONY: build blacklist rebuild clean version help

build: $(PKG) ## Build the .ipk (only if package files changed)

$(PKG): $(SOURCES) build.sh
	./build.sh

blacklist: ## Re-download the sources and regenerate blacklist.txt
	./tools/update-blacklist.sh

rebuild: ## Regenerate blacklist.txt and build the .ipk
	$(MAKE) blacklist
	$(MAKE) build

clean: ## Remove build artifacts
	rm -rf $(OUT_DIR)

version: ## Print the package version from CONTROL/control
	@echo $(VERSION)

help: ## Show this help
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | \
		sed 's/:.*## /\t/' | expand -t 12
