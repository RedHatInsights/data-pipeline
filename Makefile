.PHONY: pycco

SOURCES:=$(shell find ccx_data_pipeline test -name '*.py')
DOCFILES:=$(addprefix docs/packages/, $(addsuffix .html, $(basename ${SOURCES})))

default: pycco

docs/packages/%.html: %.py
	mkdir -p $(dir $@)
	pycco -d $(dir $@) $^

pycco: ${DOCFILES}
