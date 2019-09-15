# Kubernetes Mixins 

## Overview

Extend functionality of [Kubernetes Mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin).

- Provide configuration file to override mixin options
- Provide filter function to remove unwanted rulesand allow customized

## Install Deps

```
go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
go get github.com/brancz/gojsontoyaml  
```

## Usage

Import vendor upstream via jsonnet-bundler.
```
jb init
jb install github.com/kubernetes-monitoring/kubernetes-mixin
```
Additional configuration can be done via `main.jsonnet` and `config.jsonnet`.


Generate rendered manifests into the `./manifests` directory.

```
make
```

## TODO
- Auto-generate kustomization file
- Generate grafana dashboards as well
