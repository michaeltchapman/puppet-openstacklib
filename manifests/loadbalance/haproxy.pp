# == Class: openstacklib::loadbalance::haproxy
#
# Sets up haproxy as a loadbalancer on an internal
# and a public interface, and create a virtual IP
# using keepalived.
#
# [*cluster_public_vip*]
#   (required) The virtual IP address for the public
#   interface (string)
#
# [*cluster_private_vip*]
#   (required) The virtual IP address for the internal
#   interface (string)
#
# [*vip_secret*]
#   (required) The secret required to connect to
#   the virtual ip (string)
#
# [*public_iface*]
#   (required) The interface to use for public traffic (string)
#
# [*private_iface*]
#   (required) The interface to use for private traffic (string)
#
# [*cluster_master*]
#   (required) The fqdn of the node that will be the master
#   for the virtual IPs (string)
#
# [*cluster_names*]
#   (required) The names of the control nodes in the loadbalancing
#   cluster (list)
#
# [*cluster_addresses*]
#   (required) The IP addresses of the control nodes in the
#   loadbalancing cluster
#
# [*public_vrid*]
#   (optional) The virtual router ID for the public VIP
#   Defaults to '50'
#
# [*private_vrid*]
#   (optional) The virtual router ID for the private VIP
#   Defaults to '51'
#
class openstacklib::loadbalance::haproxy (
  $cluster_public_vip,
  $cluster_private_vip,
  $vip_secret,
  $public_iface,
  $private_iface,
  $cluster_master,
  $public_vrid = '50',
  $private_vrid = '51',
) {

  $haproxy_defaults = {
    'log'       => 'global',
    'mode'      => 'http',
    'option'    => ['httplog', 'dontlognull', 'redispatch'],
    'retries'   => '3',
    'timeout'   => ['connect 5000', 'client 10000', 'server 10000']
  }

  $haproxy_globals = {
    'log'       => '127.0.0.1 local0 notice',
    'maxconn'   => '2000',
    'user'      => 'haproxy',
    'group'     => 'haproxy',
  }

  class { '::haproxy':
    global_options   => $haproxy_globals,
    defaults_options => $haproxy_defaults
  }

  if $cluster_master == $::fqdn {
    $state = 'MASTER'
  } else {
    $state = 'BACKUP'
  }

  # configure vips
  include keepalived

  sysctl { 'net.ipv4.ip_nonlocal_bind':
    value  => '1',
    before => Class['::keepalived']
  }

  keepalived::vrrp::instance { 'public':
    interface           => $public_iface,
    state               => $state,
    virtual_router_id   => $public_vrid,
    priority            => '101',
    auth_type           => 'PASS',
    auth_pass           => $vip_secret,
    virtual_ipaddress   => [$cluster_public_vip],
  } -> Class['::haproxy']

  keepalived::vrrp::instance { 'private':
    interface           => $private_iface,
    state               => $state,
    virtual_router_id   => $private_vrid,
    priority            => '101',
    auth_type           => 'PASS',
    auth_pass           => $vip_secret,
    virtual_ipaddress   => [$cluster_private_vip],
  } -> Class['::haproxy']

  # Openstack services depend on being able to access db and mq, so make
  # sure our VIPs and LB are active before we deal with them.
  Haproxy::Listen<||> -> Anchor <| title == 'mysql::server::start' |>
  Haproxy::Listen<||> -> Anchor <| title == 'rabbitmq::begin' |>
  Haproxy::Balancermember<||> -> Anchor <| title == 'mysql::server::start' |>
  Haproxy::Balancermember<||> -> Anchor <| title == 'rabbitmq::begin' |>
  Service<| title == 'haproxy' |> -> Anchor <| title == 'rabbitmq::begin' |>
  Service<| title == 'haproxy' |> -> Anchor <| title == 'mysql::server::start' |>

}
