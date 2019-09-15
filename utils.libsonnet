// Helpers
{
  // Define a PrometheusRule resource type
  prometheusRule(namespace, alertType, prometheusLabel):: {
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
  },
  // Define a filter function to remote unwanted alerts
  filter(ignore_alerts):: {
    prometheusAlerts+:: {
      groups: std.map(
        function(group)
          group {
            rules: std.filter(
              function(rule)
                std.count(ignore_alerts, rule.alert) == 0,
              group.rules
            ),
          },
        super.groups
      ),
    },
  },
  update:: {
    prometheusAlerts+:: {
      groups: std.map(
        function(group)
          group {
            rules: std.map(
              function(rule)
                if rule.alert == 'MyExampleAlert' then
                  rule {
                    expr: 'MyUpdateExpr',
                  }
                else
                  rule,
              group.rules
            ),
          },
        super.groups
      ),
    },
  },
}
