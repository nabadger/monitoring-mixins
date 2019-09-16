// Import core configuration
local kubernetes = (import 'config.libsonnet');
local utils = (import 'lib/utils.libsonnet');

// Define a list of alerts to ignore from upstream
local ignore_alerts = [];

// Example:
//
// local ignore_alerts = [
//   'KubeAPIErrorsHigh',
//   'KubeAPILatencyHigh',
//   'KubeClientCertificateExpiration',
//] ;

// Define a list of groups to ignore from upstream
local ignore_groups = [];

// Example:
//
// local ignore_groups = [
//   'kube-scheduler.rules',
//   'kube-apiserver.rules',
// ];

// Define a mapping of alert/recordname to expression.
// the name matches a rule, then override the `expr` with
// the given value
local expr_overrides = {};

// Example:
//
// local expr_overrides = {
//   'namespace:container_cpu_usage_seconds_total:sum_rate': 'sum(rate(container_cpu_usage_seconds_total{job="cadvisor", image!="", container!="POD"}[5m])) by (namespace)',
//   KubeletDown: 'absent(up{job="kubelet"} == 1)',
// };

// Generate full output
local kp = kubernetes + utils.filterGroups(ignore_groups) + utils.filter(ignore_alerts) + utils.updateExpressions(expr_overrides);
{
  'kubernetes-prometheus-core-rules': utils.prometheusRule('monitoring', 'core', kp.prometheusRules, 'k8s'),
  'kubernetes-prometheus-alert-rules': utils.prometheusRule('monitoring', 'alert', kp.prometheusAlerts, 'k8s'),
}
