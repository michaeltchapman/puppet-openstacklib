# == Class: openstacklib::loadbalance::haproxy::rabbitmq
#
# Provides load balancing for rabbitmq
# This module is unnecessary since clients are cluster
# aware and should not access the queue via the VIP
# due to https://bugs.launchpad.net/fuel/+bug/1285449
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
#   (optional) The ports to load balance
#   Defaults to
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
    vip               => $vip,
    balancer_ports    => $ports,
    listen_options    => $listen_options,
    listen_mode       => $listen_mode,
    balancer_options  => $balancer_options,
    balancer_cookie   => $balancer_cookie,
    cluster_addresses => $cluster_addresses,
    cluster_names     => $cluster_names
  }
}
