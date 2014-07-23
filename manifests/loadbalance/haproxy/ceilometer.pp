# == Class: openstacklib::loadbalance::haproxy::ceilometer
#
# Provides load balancing for ceilometer
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
# [*ports*]
#   (optional) The ports to load balance for ceilometer
#   Defaults to ['8777']
#
# [*listen_options*]
#   (optional) Options to pass to the listen
#   section of haproxy. See haproxy module for
#   additional details.
#   Defaults to undef
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
#   Defaults to undef
#
# [*bind_options*]
#   (optional) Array of options to add to the bind line in
#   listen section
#   Defaults to undef
#
class openstacklib::loadbalance::haproxy::ceilometer(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $internal_vip       = undef,
  $ports              = ['8777'],
  $listen_options     = undef,
  $listen_mode        = 'http',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
  $bind_options       = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'ceilometer':
    vip               => $vip,
    balancer_ports    => $ports,
    listen_options    => $listen_options,
    listen_mode       => $listen_mode,
    balancer_options  => $balancer_options,
    balancer_cookie   => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names,
    bind_options      => $bind_options
  }

  if $internal_vip {
    openstacklib::loadbalance::haproxy_service { 'ceilometer-internal':
      vip               => $vip,
      balancer_ports    => $ports,
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
