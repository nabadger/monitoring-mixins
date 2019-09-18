//(import 'grafana/grafana.libsonnet') +
(import 'node-mixin/mixin.libsonnet') +
//(import 'alertmanager/alertmanager.libsonnet') +
(import 'prometheus-operator/prometheus-operator.libsonnet') +
(import 'lib/prometheus.libsonnet') +
//(import 'prometheus-adapter/prometheus-adapter.libsonnet') +
(import 'kube-prometheus/alerts/alerts.libsonnet') +
(import 'kube-prometheus/rules/rules.libsonnet') +
(import 'kubernetes-mixin/mixin.libsonnet') +
(import 'prometheus/mixin.libsonnet') + {
  //(import 'alerts/alerts.libsonnet') +
  //(import 'rules/rules.libsonnet') + {
  kubePrometheus+:: {
    namespace: 'monitoring',
  },
} + {
  _config+:: {
    namespace: 'monitoring',

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

    prometheus+:: {
      rules: $.prometheusRules + $.prometheusAlerts,
    },

    grafana+:: {
      dashboards: $.grafanaDashboards,
    },

  },
}
