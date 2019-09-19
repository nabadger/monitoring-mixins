JSONNET_FMT := jsonnet fmt -n 2 --max-blank-lines 2 --string-style s --comment-style s
JB_BINARY:=$(HOME)/go/bin/jb

all: dashboards manifests fmt

.PHONY: clean
clean:
	# Remove all files and directories ignored by git.
	git clean -Xfd .

manifests:
	@mkdir -p manifests
	jsonnet -J vendor -m manifests manifests.jsonnet

dashboards:
	@mkdir -p dashboards
	jsonnet -J vendor -m dashboards dashboards.jsonnet


vendor: jsonnetfile.json jsonnetfile.lock.json
	rm -rf vendor
	$(JB_BINARY) install

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

.PHONY: manifests dashboards fmt
