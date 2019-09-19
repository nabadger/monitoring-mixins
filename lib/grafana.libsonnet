{
  _config+:: {
    namespace: 'default',

    versions+:: {
      grafana: '6.2.1',
    },

    imageRepos+:: {
      grafana: 'grafana/grafana',
    },

    grafana+:: {
      dashboards: {},
      datasources: [{
        name: 'prometheus',
        type: 'prometheus',
        access: 'proxy',
        orgId: 1,
        url: 'http://prometheus-k8s.' + $._config.namespace + '.svc:9090',
        version: 1,
        editable: false,
      }],
      config: {},
      ldap: null,
      plugins: [],
      container: {
        requests: { cpu: '100m', memory: '100Mi' },
        limits: { cpu: '200m', memory: '200Mi' },
      },
    },
  },
  grafana+: {
    dashboardDefinitions: {
      //'apiserver.json': $._config.grafana.dashboards['apiserver.json'],
      //local dashboardName = 'grafana-dashboard-' + std.strReplace(name, '.json', '');
      [name]: $._config.grafana.dashboards[name]
      for name in std.objectFields($._config.grafana.dashboards)
    },
  },
}
