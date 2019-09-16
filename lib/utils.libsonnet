{
  // Define a PrometheusRule resource type
  prometheusRule(namespace, name, alertType, prometheusLabel):: {
    apiVersion: 'monitoring.kubernetesos.com/v1',
    kind: 'PrometheusRule',
    metadata: {
      labels: {
        prometheus: prometheusLabel,
        role: 'alert-rules',
      },
      name: 'prometheus-' + name + '-rules',
      namespace: namespace,
    },
    spec: alertType,
  },
  // Define a filter function to remove unwanted alerts
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

  // Define a filter function to remove unwanted groups
  filterGroups(ignore_groups):: {
    prometheusRules+:: {
      groups: std.filter(
        function(group)
          std.count(ignore_groups, group.name) == 0,
        super.groups
      ),
    },
    prometheusAlerts+:: {
      groups: std.filter(
        function(group)
          std.count(ignore_groups, group.name) == 0,
        super.groups
      ),
    },
  },
  // WIP: Define update function for rules
  // TODO: Define an external map of rule-name -> expr to avoid inline
  // if-statement
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
