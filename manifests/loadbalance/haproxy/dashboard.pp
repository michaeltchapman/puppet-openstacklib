class openstacklib::loadbalance::haproxy::dashboard(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $ports              = ['80'],
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'dashboard':
    vip              => $vip,
    balancer_ports   => $ports,
    listen_options   => $listen_options,
    listen_mode      => $listen_mode,
    balancer_options => $balancer_options,
    balancer_cookie  => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names    => $cluster_names
  }
}
