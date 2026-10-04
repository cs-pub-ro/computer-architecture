TYPST ?= typst
BUILD_DIR := build
OUTPUT := $(BUILD_DIR)/midterm-model.pdf
SOURCES := $(shell find . -type f -name '*.typ' -not -path './$(BUILD_DIR)/*') \
	../../labs/common/template.typ ../../labs/common/config.typ

.PHONY: all pdf preview check clean FORCE

all: pdf

pdf: $(OUTPUT)

$(OUTPUT): $(SOURCES) FORCE | $(BUILD_DIR)
	$(TYPST) compile --root ../.. main.typ $@

$(BUILD_DIR):
	mkdir -p $@

preview: | $(BUILD_DIR)
	$(TYPST) watch --root ../.. main.typ $(OUTPUT)

check: pdf
	$(TYPST) eval --root ../.. 'let sections = query(heading.where(level: 1)).filter(item => item.outlined).map(item => repr(item.body)); assert(sections == ("sequence([ALU Operations], [ ], [(4-bit)])", "[ALU Operations with Registers]", "[Moore Finite State Machine]", "[Truth Table to Gate Name]", "[Truth Table Output Identification]")); let answers = query(heading.where(level: 2)).map(item => repr(item.body)); assert(answers == ("[Problem]", "[Solution]", "[Problem]", "[Solution]", "[Problem]", "[Solution]", "[Problem]", "[Solution]", "[Problem]", "[Solution]")); assert(query(heading.where(level: 3)).filter(item => item.outlined).len() == 0); assert(query(heading.where(level: 4)).filter(item => item.outlined).len() == 0)' --in main.typ

FORCE:

clean:
	rm -rf $(BUILD_DIR)