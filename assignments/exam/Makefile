TYPST ?= typst
BUILD_DIR := build
OUTPUT := $(BUILD_DIR)/exam-model.pdf
SOURCES := $(shell find . -type f -name '*.typ' -not -path './$(BUILD_DIR)/*') \
	../../labs/common/template.typ ../../labs/common/config.typ

.PHONY: all pdf preview clean

all: pdf

pdf: $(OUTPUT)

$(OUTPUT): $(SOURCES) | $(BUILD_DIR)
	$(TYPST) compile --root ../.. main.typ $@

$(BUILD_DIR):
	mkdir -p $@

preview:
	$(TYPST) watch --root ../.. main.typ $(OUTPUT)

clean:
	rm -rf $(BUILD_DIR)