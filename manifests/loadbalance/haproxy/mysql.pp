class openstacklib::loadbalance::haproxy::mysql
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $ports              = ['3306'],
  $listen_options     = {
    'timeout' => [
      'connect 10000',
      'client 50000',
      'server 50000',
    ],
    'option' => [
      'tcpka',
      'tcplog',
    ]
  },
  $listen_mode        = 'tcp',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'mysql':
    vip              => $vip,
    balancer_ports   => $ports,
    listen_options   => $listen_options,
    listen_mode      => $listen_mode,
    balancer_options => $balancer_options,
    balancer_cookie  => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names
  }
}
