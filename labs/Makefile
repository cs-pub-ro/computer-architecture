TYPST ?= typst
LABS := $(patsubst %/main.typ,%,$(wildcard [0-9]/main.typ [0-9][0-9]/main.typ))
PDFS := $(addprefix build/lab-,$(addsuffix .pdf,$(LABS)))

.PHONY: all check clean FORCE

all: $(PDFS)

check:
	python3 check.py

build/lab-%.pdf: %/main.typ FORCE | build
	$(TYPST) compile --root .. $< $@

build:
	mkdir -p $@

FORCE:

clean:
	rm -rf build