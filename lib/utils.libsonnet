{
  // Define a PrometheusRule resource type
  prometheusRule(namespace, name, alertType, prometheusLabel):: {
    apiVersion: 'monitoring.coreos.com/v1',
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
  // Update expressions for either alerts or record definitions.
  updateExpressions(expr_overrides):: {
    prometheusRules+:: {
      groups: std.map(
        function(group)
          group {
            rules: std.map(
              function(rule)
                if std.objectHas(expr_overrides, rule.record) then
                  rule {
                    expr: expr_overrides[rule.record],
                  }
                else
                  rule,
              group.rules
            ),
          },
        super.groups
      ),
    },
    prometheusAlerts+:: {
      groups: std.map(
        function(group)
          group {
            rules: std.map(
              function(rule)
                if std.objectHas(expr_overrides, rule.alert) then
                  rule {
                    expr: expr_overrides[rule.alert],
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
