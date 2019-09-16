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

## Configuration

Upstream configuration of *kubernetes-mixin* can be done in `config.jsonnet`

For modifiying rules and alerts use `main.jsonnet`

- *ignore_groups* - filter out entire groups (handy for managed clusters such as GKE where you cannot monitor the api-server).
- *ignore_rules* - filter out specific rules by name




## TODO
- Auto-generate kustomization file
- Generate grafana dashboards as well
- Allow configuration of rule-expression overrides