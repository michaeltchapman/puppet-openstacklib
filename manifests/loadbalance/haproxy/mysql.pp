# == Class: openstacklib::loadbalance::haproxy::mysql
#
# Provides load balancing for mysql
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
#   (optional) The ports to load balance for mysql
#   Defaults to ['3306']
#
# [*listen_options*]
#   (optional) Options to pass to the listen
#   section of haproxy. See haproxy module for
#   additional details.
#   Defaults to {
#     'timeout' => ['connect 10000',
#                   'client 50000',
#                   'server 50000'],
#     'option'  => ['tcpka', 'tcplog']
#   }
#
# [*listen_mode*]
#   (optional) The listen mode to be configured in
#   haproxy for this service
#   Defaults to 'tcp'
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
class openstacklib::loadbalance::haproxy::mysql
(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $ports              = ['3306'],
  $listen_options     = {
    'timeout' => [
      'connect 10000',
      'client 50000',
      'server 50000',
    ],
    'option' => [
      'tcpka',
      'tcplog',
    ]
  },
  $listen_mode        = 'tcp',
  $balancer_options   = undef,
  $balancer_cookie    = undef,
)
{
  openstacklib::loadbalance::haproxy_service { 'mysql':
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
