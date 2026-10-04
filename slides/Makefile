TYPST ?= typst
BUILD_DIR ?= build
COURSES := $(patsubst courses/%/main.typ,%,$(wildcard courses/*/main.typ))
PDFS := $(addprefix $(BUILD_DIR)/course-,$(addsuffix .pdf,$(COURSES)))

.PHONY: all clean FORCE

all: $(PDFS)

$(BUILD_DIR)/course-%.pdf: courses/%/main.typ FORCE | $(BUILD_DIR)
	$(TYPST) compile --root . $< $@

$(BUILD_DIR):
	mkdir -p $@

FORCE:

clean:
	rm -rf $(BUILD_DIR)