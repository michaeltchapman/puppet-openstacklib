class openstacklib::loadbalance::haproxy::neutron
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $ports              = ['9696'],
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'neutron':
    vip              => $vip,
    balancer_ports   => $ports,
    listen_options   => $listen_options,
    listen_mode      => $listen_mode,
    balancer_options => $balancer_options,
    balancer_cookie  => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names
  }

  if $internal_vip {
    openstacklib::loadbalance::haproxy_service { 'neutron-internal':
      vip              => $internal_vip,
      balancer_ports   => $ports,
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }
}
