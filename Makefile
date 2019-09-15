JSONNET_FMT := jsonnet fmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
JB_BINARY:=$(HOME)/go/bin/jb

all: generate fmt

.PHONY: clean
clean:
	# Remove all files and directories ignored by git.
	git clean -Xfd .

generate: manifests

manifests: vendor build.sh
	rm -rf manifests
	./build.sh ./main.jsonnet

vendor: jsonnetfile.json jsonnetfile.lock.json
	rm -rf vendor
	$(JB_BINARY) install

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: generate fmt
