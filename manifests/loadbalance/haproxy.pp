class openstacklib::loadbalance::haproxy (
  $cluster_public_vip,
  $cluster_private_vip,
  $vip_secret,
  $public_iface,
  $private_iface,
  $cluster_master,
  $cluster_names,
  $cluster_addresses,

  $haproxy_defaults = {
      'log' => 'global',
      'mode'=> 'http',
      'option' => ['httplog', 'dontlognull', 'redispatch'],
      'retries' => '3',
      'timeout' => ['connect 5000', 'client 10000', 'server 10000']
  },

  $haproxy_globals = {
      'log' => '127.0.0.1 local0 notice',
      'maxconn' => '2000',
      'user'    => 'haproxy',
      'group'    => 'haproxy',
  },
) {

  class { '::haproxy':
    global_options => $haproxy_globals,
    defaults_options => $haproxy_defaults
  }

  if $cluster_master == $::fqdn {
    $state = 'MASTER'
  } else {
    $state = 'BACKUP'
  }

  # configure vips
  include keepalived

  sysctl::value { "net.ipv4.ip_nonlocal_bind":
    value => '1',
    before => Class['::keepalived']
  }

  keepalived::vrrp::instance { 'public':
    interface =>  $public_iface,
    state     =>  $state,
    virtual_router_id => '50',
    priority  => '101',
    auth_type         => 'PASS',
    auth_pass         => $vip_secret,
    virtual_ipaddress => $cluster_public_vip,
  } -> Class['::haproxy']

  keepalived::vrrp::instance { 'private':
    interface =>  $private_iface,
    state     =>  $state,
    virtual_router_id => '51',
    priority  => '101',
    auth_type         => 'PASS',
    auth_pass         => $vip_secret,
    virtual_ipaddress => $cluster_private_vip,
  } -> Class['::haproxy']

  # Openstack services depend on being able to access db and mq, so make
  # sure our VIPs and LB are active before we deal with them.
  Haproxy::Listen<||> -> Class['::mysql::server']
  Haproxy::Listen<||> -> Class['::rabbitmq']
  Haproxy::Balancermember<||> -> Class['::mysql::server']
  Haproxy::Balancermember<||> -> Class['::rabbitmq']

}

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
) { 

  haproxy::listen { "${name}":
    ipaddress        => $vip,
    ports            => $balancer_ports,
    mode             => $listen_mode,
    collect_exported => false,
    options          => $listen_options,
  }

  haproxy::balancermember { $name:
    listening_service => "${name}",
    ports             => $balancer_ports,
    server_names      => $cluster_names,
    ipaddresses       => $cluster_addresses,
    options           => $balancer_options,
    define_cookies    => $balancer_cookie
  }
}