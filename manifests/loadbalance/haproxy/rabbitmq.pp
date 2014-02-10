class openstacklib::loadbalance::haproxy::rabbitmq
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $ports              = ['5672'],
  $listen_options     = {
    'option' => [
      'tcpka',
      'tcplog'
    ],
  },
  $listen_mode        = 'tcp',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'rabbitmq':
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
