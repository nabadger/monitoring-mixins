// Import core configuration
local kubernetes = (import 'config.libsonnet');
local utils = (import 'utils.libsonnet');

// Define a list of alerts to ignore (filter them out from upstream)
local ignore_alerts = [
  'KubeAPIErrorsHigh',
  'KubeAPILatencyHigh',
  'KubeClientCertificateExpiration',
];

// Generate full output
local kp = kubernetes + utils.filter(ignore_alerts) + utils.update;
{
  'kubernetes-prometheus-core-rules': utils.prometheusRule('monitoring', 'core', kp.prometheusRules, 'k8s'),
  'kubernetes-prometheus-alert-rules': utils.prometheusRule('monitoring', 'alert', kp.prometheusAlerts, 'k8s'),
}
