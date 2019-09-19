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
jb install
```

Generate rendered manifests into the `./manifests` directory.

```
make
```

This renders prometheus rules into `./manifests` and grafana dashboards into `./dashboards`.


## Configuration

Upstream configuration of *kubernetes-mixin* can be done in `config.jsonnet`

Modifiying rules and alerts can be done in `main.jsonnet`

### Ignoring Groups

Filter out entire groups (handy for managed clusters such as GKE where you cannot monitor the api-server).

```
local ignore_groups = [
  'kube-scheduler.rules',
  'kube-apiserver.rules'
];
```

### Ignoring Alerts

Filter out specific rules by name

```
local ignore_alerts = [
  'KubeAPIErrorsHigh',
  'KubeAPILatencyHigh',
  'KubeClientCertificateExpiration'
];
```

### Updating Expressions

A map of expression overrides where the key is either rule.alert or rule.record name and the value is the new expression.

```
local expr_overrides = {
  'namespace:container_cpu_usage_seconds_total:sum_rate': 'sum(rate(container_cpu_usage_seconds_total{job="cadvisor", image!="", container!="POD"}[5m])) by (namespace)',
  KubeletDown: 'absent(up{job="kubelet"} == 1)',
};
```
