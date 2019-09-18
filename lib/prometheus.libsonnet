{
  _config+:: {
    namespace: 'default',

    versions+:: {
      prometheus: 'v2.11.0',
    },

    imageRepos+:: {
      prometheus: 'quay.io/prometheus/prometheus',
    },

    alertmanager+:: {
      name: 'main',
    },

    prometheus+:: {
      name: 'k8s',
      replicas: 2,
      rules: {},
      renderedRules: {},
      namespaces: ['default', 'kube-system', $._config.namespace],
    },
  },


  prometheus+:: {
    [if $._config.prometheus.rules != null && $._config.prometheus.rules != {} then 'rules']:
      {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'PrometheusRule',
        metadata: {
          labels: {
            prometheus: $._config.prometheus.name,
            role: 'alert-rules',
          },
          name: 'prometheus-' + $._config.prometheus.name + '-rules',
          namespace: $._config.namespace,
        },
        spec: {
          groups: $._config.prometheus.rules.groups,
        },
      },
  },
}
