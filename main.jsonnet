// Import core configuration
local kubernetes = (import 'config.libsonnet');
local utils = (import 'utils.libsonnet');

// Define a list of alerts to ignore from upstream
local ignore_alerts = [
  'KubeAPIErrorsHigh',
  'KubeAPILatencyHigh',
  'KubeClientCertificateExpiration',
];

// Define a list of groups to ignore from upstream
local ignore_groups = [
  'kube-scheduler.rules',
  'kube-apiserver.rules',
];


// Generate full output
local kp = kubernetes + utils.filterGroups(ignore_groups) + utils.filter(ignore_alerts) + utils.update;
{
  'kubernetes-prometheus-core-rules': utils.prometheusRule('monitoring', 'core', kp.prometheusRules, 'k8s'),
  'kubernetes-prometheus-alert-rules': utils.prometheusRule('monitoring', 'alert', kp.prometheusAlerts, 'k8s'),
}
