# == Type openstacklib::loadbalance::haproxy_service
#
# Creates a pair of types from the haproxy module
# with the supplied parameters
#
define openstacklib::loadbalance::haproxy_service (
  $vip,
  $balancer_ports,
  $cluster_addresses,
  $cluster_names,
  $listen_options   =  {
    'balance' => 'roundrobin'
  },
  $listen_mode      = 'http',
  $balancer_options = 'check inter 10s',
  $balancer_cookie  = undef,
  $bind_options     = undef,
) {

  haproxy::listen { $name:
    ipaddress        => $vip,
    ports            => $balancer_ports,
    mode             => $listen_mode,
    collect_exported => false,
    options          => $listen_options,
    bind_options     => $bind_options
  }

  haproxy::balancermember { $name:
    listening_service => $name,
    ports             => $balancer_ports,
    server_names      => $cluster_names,
    ipaddresses       => $cluster_addresses,
    options           => $balancer_options,
    define_cookies    => $balancer_cookie
  }
}
