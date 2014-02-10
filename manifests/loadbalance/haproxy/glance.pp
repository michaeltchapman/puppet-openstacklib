class openstacklib::loadbalance::haproxy::glance(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $glance_port        = '9191',
  $registry_port      = '9292',
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  if $glance_port {
    openstacklib::loadbalance::haproxy_service { 'glance-api':
      vip              => $vip,
      balancer_ports   => $glance_port,
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $registry_port {
    openstacklib::loadbalance::haproxy_service { 'glance-registry':
      vip              => $vip,
      balancer_ports   => $registry_port,
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $internal_vip {
    if $glance_port {
      openstacklib::loadbalance::haproxy_service { 'glance-api-internal':
        vip              => $internal_vip,
        balancer_ports   => $glance_port,
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }
  
    if $registry_port {
      openstacklib::loadbalance::haproxy_service { 'glance-registry-internal':
        vip              => $internal_vip,
        balancer_ports   => $registry_port,
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
