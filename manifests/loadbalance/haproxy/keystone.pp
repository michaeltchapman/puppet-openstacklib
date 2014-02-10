class openstacklib::loadbalance::haproxy::keystone
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $public_port        = '5000',
  $admin_port         = '35357',
  $listen_options     = {
    'option' => ['httpchk'] 
  },
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = true,
)
{
  openstacklib::loadbalance::haproxy_service { 'keystone-public':
    vip              => $vip,
    balancer_ports   => [$public_port],
    listen_options   => $listen_options,
    listen_mode      => $listen_mode,
    balancer_options => $balancer_options,
    balancer_cookie  => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names
  }

  if $internal_vip {
    openstacklib::loadbalance::haproxy_service { 'keystone-public-internal':
      vip              => $internal_vip,
      balancer_ports   => [$public_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  
    openstacklib::loadbalance::haproxy_service { 'keystone-admin-internal':
      vip              => $internal_vip,
      balancer_ports   => [$admin_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  } else {
    notice('Keystone admin api is being placed on public vip.')
    openstacklib::loadbalance::haproxy_service { 'keystone-admin-internal':
      vip              => $vip,
      balancer_ports   => [$admin_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }
}
