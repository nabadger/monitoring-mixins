{
  grafana+: {
    dashboardDefinitions: {
      //'apiserver.json': $._config.grafana.dashboards['apiserver.json'],
      //local dashboardName = 'grafana-dashboard-' + std.strReplace(name, '.json', '');
      [name]: $._config.grafana.dashboards[name]
      for name in std.objectFields($._config.grafana.dashboards)
    },
  },
}
