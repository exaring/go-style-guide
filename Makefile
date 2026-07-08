SHELL = /bin/bash

# Setting GOBIN makes 'go install' put the binary in the bin/ directory.
export GOBIN ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/bin

STITCHMD = $(GOBIN)/stitchmd

# Keep these options in-sync with .github/workflows/ci.yml.
STITCHMD_ARGS = -o style.md -preface src/preface.txt src/SUMMARY.md

.PHONY: all
all: style.md style-for-agents.md

.PHONY: lint
lint: $(STITCHMD)
	@DIFF=$$($(STITCHMD) -d $(STITCHMD_ARGS)); \
	if [[ -n "$$DIFF" ]]; then \
		echo "style.md is out of date:"; \
		echo "$$DIFF"; \
		false; \
	fi
	@TMP=$$(mktemp); \
	./tools/gen-style-for-agents.sh "$$TMP"; \
	if ! diff -u style-for-agents.md "$$TMP"; then \
		echo "style-for-agents.md is out of date; run 'make'"; \
		rm -f "$$TMP"; \
		false; \
	fi; \
	rm -f "$$TMP"

style.md: $(STITCHMD) $(wildcard src/*)
	$(STITCHMD) $(STITCHMD_ARGS)

style-for-agents.md: tools/gen-style-for-agents.sh $(wildcard src/*)
	./tools/gen-style-for-agents.sh $@

$(STITCHMD):
	go install go.abhg.dev/stitchmd@latest
