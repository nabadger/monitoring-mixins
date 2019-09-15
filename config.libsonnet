local kubernetes = (import 'kubernetes-mixin/mixin.libsonnet');

// Customise the mixin config as required
// 	- Override job labels
//	- Modify / components
kubernetes {
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    cadvisorSelector: 'job="cadvisor"',
    kubeletSelector: 'job="kubelet"',
    kubeStateMetricsSelector: 'job="kube-state-metrics"',
    nodeExporterSelector: 'job="node-exporter"',
    notKubeDnsCoreDnsSelector: 'job!~"kube-dns|coredns"',
    kubeSchedulerSelector: 'job="kube-scheduler"',
    kubeControllerManagerSelector: 'job="kube-controller-manager"',
    kubeApiserverSelector: 'job="kube-apiserver"',
    kubeProxySelector: 'job="kube-proxy"',
    podLabel: 'pod',
    namespaceSelector: null,
    prefixedNamespaceSelector: if self.namespaceSelector != null then self.namespaceSelector + ',' else '',
    hostNetworkInterfaceSelector: 'device!~"veth.+"',
    hostMountpointSelector: 'mountpoint="/"',
    wmiExporterSelector: 'job="wmi-exporter"',

    // We build alerts for the presence of all these jobs.
    jobs: {
      Kubelet: $._config.kubeletSelector,
      // NOTE: Comment out to support GKE
      // KubeScheduler: $._config.kubeSchedulerSelector,
      // KubeControllerManager: $._config.kubeControllerManagerSelector,
      // KubeAPI: $._config.kubeApiserverSelector,
    },

    // We alert when the aggregate (CPU, Memory) quota for all namespaces is
    // greater than the amount of the resources in the cluster.  We do however
    // allow you to overcommit if you wish.
    namespaceOvercommitFactor: 1.5,
    kubeletPodLimit: 110,
    certExpirationWarningSeconds: 7 * 24 * 3600,
    certExpirationCriticalSeconds: 1 * 24 * 3600,
    cpuThrottlingPercent: 25,
    cpuThrottlingSelector: '',
    kubeAPILatencyWarningSeconds: 1,
    kubeAPILatencyCriticalSeconds: 4,

    // We alert when a disk is expected to fill up in four days. Depending on
    // the data-set it might be useful to change the sampling-time for the
    // prediction
    volumeFullPredictionSampleTime: '6h',


    // Opt-in to multiCluster dashboards by overriding this and the clusterLabel.
    showMultiCluster: false,
    clusterLabel: 'cluster',

    // This list of filesystem is referenced in various expressions.
    fstypes: ['ext[234]', 'btrfs', 'xfs', 'zfs'],
    fstypeSelector: 'fstype=~"%s"' % std.join('|', self.fstypes),

    // This list of disk device names is referenced in various expressions.
    diskDevices: ['nvme.+', 'rbd.+', 'sd.+', 'vd.+', 'xvd.+', 'dm-.+'],
    diskDeviceSelector: 'device=~"%s"' % std.join('|', self.diskDevices),
  },
}
