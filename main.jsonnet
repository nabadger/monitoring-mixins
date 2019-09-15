//local kubernetes = (import 'kubernetes-mixin/mixin.libsonnet');
local kubernetes = (import 'config.libsonnet');


local prometheusRule(namespace, alertType, prometheusLabel) = {
  apiVersion: 'monitoring.kubernetesos.com/v1',
  kind: 'PrometheusRule',
  metadata: {
    labels: {
      prometheus: prometheusLabel,
      role: 'alert-rules',
    },
    name: 'prometheus--rules',
    namespace: namespace,
  },
  spec: alertType,
};

{
  'kubernetes-prometheus-rules': prometheusRule('monitoring', kubernetes.prometheusAlerts, 'k8s'),
}
