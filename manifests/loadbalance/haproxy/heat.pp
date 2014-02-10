class openstacklib::loadbalance::haproxy::heat(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $heat_port          = '8004',
  $cfn_port           = '8000',
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{  
  if $heat_port {
    openstacklib::loadbalance::haproxy_service { 'heat-api':
      vip              => $vip,
      balancer_ports   => [$heat_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $cfn_port {
    openstacklib::loadbalance::haproxy_service { 'heat-cfn-internal':
      vip              => $internal_vip,
      balancer_ports   => [$cfn_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $internal_vip {
    if $heat_port {
      openstacklib::loadbalance::haproxy_service { 'heat-api-internal':
        vip              => $internal_vip,
        balancer_ports   => [$heat_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }

    if $cfn_port {
      openstacklib::loadbalance::haproxy_service { 'heat-cfn':
        vip              => $vip,
        balancer_ports   => [$cfn_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }
  }
}
