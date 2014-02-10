class openstacklib::loadbalance::haproxy::nova
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $nova_port          = '8774',
  $ec2_port           = '8773',
  $vncproxy_port      = '6080',
  $metadata_port      = '8775',
  $objectstore_port   = '3333',
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{

  if $nova_port {
    openstacklib::loadbalance::haproxy_service { 'nova-api':
      vip              => $vip,
      balancer_ports   => [$nova_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $ec2_port {
    openstacklib::loadbalance::haproxy_service { 'nova-ec2':
      vip              => $vip,
      balancer_ports   => [$ec2_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $vncproxy_port {
    openstacklib::loadbalance::haproxy_service { 'nova-novnc':
      vip              => $vip,
      balancer_ports   => [$vncproxy_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $metadata_port {
    openstacklib::loadbalance::haproxy_service { 'nova-metadata':
      vip              => $vip,
      balancer_ports   => [$metadata_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $objectstore_port {
    openstacklib::loadbalance::haproxy_service { 'nova-objectstore':
      vip              => $vip,
      balancer_ports   => [$objectstore_port],
      listen_options   => $listen_options,
      listen_mode      => $listen_mode,
      balancer_options => $balancer_options,
      balancer_cookie  => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names
    }
  }

  if $internal_vip { 
    if $nova_port {
      openstacklib::loadbalance::haproxy_service { 'nova-api-internal':
        vip              => $internal_vip,
        balancer_ports   => [$nova_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }

    if $ec2_port {
      openstacklib::loadbalance::haproxy_service { 'nova-ec2-internal':
        vip              => $internal_vip,
        balancer_ports   => [$ec2_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }

    if $vncproxy_port {
      openstacklib::loadbalance::haproxy_service { 'nova-novnc-internal':
        vip              => $internal_vip,
        balancer_ports   => [$vncproxy_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }

    if $metadata_port {
      openstacklib::loadbalance::haproxy_service { 'nova-metadata-internal':
        vip              => $internal_vip,
        balancer_ports   => [$metadata_port],
        listen_options   => $listen_options,
        listen_mode      => $listen_mode,
        balancer_options => $balancer_options,
        balancer_cookie  => $balancer_cookie,
        cluster_addresses => $cluster_addresses,
        cluster_names     => $cluster_names
      }
    }

    if $objectstore_port {
      openstacklib::loadbalance::haproxy_service { 'nova-objectstore-internal':
        vip              => $internal_vip,
        balancer_ports   => [$objectstore_port],
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
