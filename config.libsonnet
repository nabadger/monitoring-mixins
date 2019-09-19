local utils = (import 'lib/utils.libsonnet');

// Define a list of alerts to ignore from upstream
local enableGKESupport = true;

// Define a list of alerts to ignore from upstream
local ignore_alerts = if enableGKESupport then [
  'KubeSchedulerDown',
  'KubeControllerManagerDown',
  'KubeAPIErrorsHigh',
  'KubeAPILatencyHigh',
  'KubeClientCertificateExpiration',
] else [];

// Define a list of groups to ignore from upstream
local ignore_groups = if enableGKESupport then [
  'kube-scheduler.rules',
  'kube-apiserver.rules',
] else [];

// Define a mapping of alert/recordname to expression.
// Overrides the expr field for the specifeid record name.
local expr_overrides = {};

// Create our updates - they will get applied to the generated jsonnet
local updates = utils.filterGroups(ignore_groups) + utils.filterAlerts(ignore_alerts);

//
// Core configuration
//
(import 'grafana/grafana.libsonnet') +
(import 'node-mixin/mixin.libsonnet') +
(import 'prometheus-operator/prometheus-operator.libsonnet') +
//(import 'prometheus-adapter/prometheus-adapter.libsonnet') +
(import 'kube-prometheus/alerts/alerts.libsonnet') +
(import 'kube-prometheus/rules/rules.libsonnet') +
(import 'kubernetes-mixin/mixin.libsonnet') +
(import 'prometheus/mixin.libsonnet') +
(import 'lib/prometheus.libsonnet') +
(import 'lib/grafana.libsonnet') + updates + {
  _config+:: {
    namespace:: error 'namespace is required',

    cadvisorSelector: 'job="kubelet"',
    kubeletSelector: 'job="kubelet"',
    kubeStateMetricsSelector: 'job="kube-state-metrics"',
    nodeExporterSelector: 'job="node-exporter"',
    notKubeDnsSelector: 'job!="kube-dns"',
    kubeSchedulerSelector: 'job="kube-scheduler"',
    kubeControllerManagerSelector: 'job="kube-controller-manager"',
    kubeApiserverSelector: 'job="apiserver"',
    coreDNSSelector: 'job="kube-dns"',
    podLabel: 'pod',

    alertmanagerSelector: 'job="alertmanager-' + $._config.alertmanager.name + '",namespace="' + $._config.namespace + '"',
    prometheusSelector: 'job="prometheus-' + $._config.prometheus.name + '",namespace="' + $._config.namespace + '"',
    prometheusName: '{{$labels.namespace}}/{{$labels.pod}}',
    prometheusOperatorSelector: 'job="prometheus-operator",namespace="' + $._config.namespace + '"',

    jobs: {
      Kubelet: $._config.kubeletSelector,
      KubeScheduler: $._config.kubeSchedulerSelector,
      KubeControllerManager: $._config.kubeControllerManagerSelector,
      KubeAPI: $._config.kubeApiserverSelector,
      KubeStateMetrics: $._config.kubeStateMetricsSelector,
      NodeExporter: $._config.nodeExporterSelector,
      Alertmanager: $._config.alertmanagerSelector,
      Prometheus: $._config.prometheusSelector,
      PrometheusOperator: $._config.prometheusOperatorSelector,
      CoreDNS: $._config.coreDNSSelector,
    },

    alertmanager+:: {
      name: 'main',
    },


    prometheus+:: {
      name: 'k8s',
      namespaces: ['kube-system', $._config.namespace],
      rules: $.prometheusRules + $.prometheusAlerts,
    },
    grafana+:: {
      dashboards: $.grafanaDashboards,
    },
  },
}
