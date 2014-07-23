# == Class: openstacklib::loadbalance::haproxy::keystone
#
# Provides load balancing for keystone
#
# === Parameters:
#
# [*vip*]
#   (required) The virtual IP for public endpoints
#
# [*cluster_addresses*]
#   (required) List of IPs in the control cluster
#   on the interface that provides this service.
#   For API endpoints this is generally the public
#   address.
#
# [*cluster_names*]
#   (required) List of names of control servers
#
# [*internal_vip*]
#   (optional) The virtual IP for internal endpoints
#   Defaults to undef
#
# [*public_port*]
#   (optional) The port to load balance for public keystone api
#   Defaults to '5000'
#
# [*admin_port*]
#   (optional) The port to load balance for admin keystone api
#   Defaults to '35357'
#
# [*listen_options*]
#   (optional) Options to pass to the listen
#   section of haproxy. See haproxy module for
#   additional details.
#   Defaults to { 'option' => ['httpchk'] }
#
# [*listen_mode*]
#   (optional) The listen mode to be configured in
#   haproxy for this service
#   Defaults to 'http'
#
# [*balancer_options*]
#   (optional) Options to pass to the balancer
#   in haproxy. See haproxy module for more details.
#   Defaults to undef
#
# [*balancer_cookie*]
#   (optional) A cookie to set in the
#   balancer member in haproxy.
#   Defaults to true
#
# [*bind_options*]
#   (optional) Array of options to add to the bind line in
#   listen section
#   Defaults to undef
#
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
  $bind_options       = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'keystone-public':
    vip               => $vip,
    balancer_ports    => [$public_port],
    listen_options    => $listen_options,
    listen_mode       => $listen_mode,
    balancer_options  => $balancer_options,
    balancer_cookie   => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names,
    bind_options      => $bind_options
  }

  if $internal_vip {
    openstacklib::loadbalance::haproxy_service { 'keystone-public-internal':
      vip               => $internal_vip,
      balancer_ports    => [$public_port],
      listen_options    => $listen_options,
      listen_mode       => $listen_mode,
      balancer_options  => $balancer_options,
      balancer_cookie   => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names,
      bind_options      => $bind_options
    }

    openstacklib::loadbalance::haproxy_service { 'keystone-admin-internal':
      vip               => $internal_vip,
      balancer_ports    => [$admin_port],
      listen_options    => $listen_options,
      listen_mode       => $listen_mode,
      balancer_options  => $balancer_options,
      balancer_cookie   => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names,
      bind_options      => $bind_options
    }
  } else {
    notice('Keystone admin api is being placed on public vip.')
    openstacklib::loadbalance::haproxy_service { 'keystone-admin-internal':
      vip               => $vip,
      balancer_ports    => [$admin_port],
      listen_options    => $listen_options,
      listen_mode       => $listen_mode,
      balancer_options  => $balancer_options,
      balancer_cookie   => $balancer_cookie,
      cluster_addresses => $cluster_addresses,
      cluster_names     => $cluster_names,
      bind_options      => $bind_options
    }
  }
}
