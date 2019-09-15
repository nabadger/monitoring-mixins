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
  'kubernetes-prometheus-rules': utils.prometheusRule('monitoring', kp.prometheusAlerts, 'k8s'),
}
