# Kubernetes Mixins 

## Overview

Extend [Kubernetes Mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin) and allow customized
options, such as Prometheus Rules.

## Usage


Initialize jsonnetfile and vendored in the `kubernetes-mixin` repo into the `./vendor` directory


## Install Deps

```
go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
go get github.com/brancz/gojsontoyaml  
```

```
jb init
jb install github.com/kubernetes-monitoring/kubernetes-mixin
```

## Render manifests

```
./build.sh main.jsonnet
```

## Render dashboards
```
jsonnet -J vendor -e '(import "config.libsonnet").grafanaDashboards' > dashboards/grafanaDashboards.yaml
```

## Kustomization

There is also an included `kustomziation.yaml` to render the PrometheusRules.

- TODO: Auto-generate this
