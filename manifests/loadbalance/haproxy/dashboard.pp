# == Class: openstacklib::loadbalance::haproxy::dashboard
#
# Provides load balancing for dashboard
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
#   (optional) The ports to load balance for the dashboard
#   Defaults to ['80']
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
# [*enable_ssl*]
#   (optional) Turn on an SSL frontend on 443 and a redirect for
#   http traffic. If no cert_path is specified, an ssl key must be
#   specified in bind_options
#   Defaults to false
#
# [*cert_path*]
#   (optional) If SSL is enabled, this can be used to specify the
#   cert to use if no other bind options are to be used. If you need
#   other bind options then use the bind_options to specify everything
#   instead.
#   Defaults to undef
#
# [*ssl_ciphers*]
#   (optional) If cert_path is used, this can be used to specify an array of ciphers
#   to append to the end
#   Defaults to undef
#
class openstacklib::loadbalance::haproxy::dashboard(
  $vip,
  $cluster_addresses,
  $cluster_names,
  $ports              = ['80'],
  $listen_options     = {
    'balance' => 'roundrobin'
  },
  $listen_mode        = 'http',
  $balancer_options   = 'check inter 10s',
  $balancer_cookie    = undef,
  $bind_options       = undef,
  $enable_ssl         = false,
  $cert_path          = undef,
  $ssl_ciphers        = undef,
)
{
  if $enable_ssl {

    if $ssl_ciphers {
      $c = join($ssl_ciphers, ':')
      $ciphers = "ciphers ${c}"
    } else {
      $ciphers = ''
    }

    if $bind_options {
        $real_bind_options = $bind_options
    } else {
      if $cert_path {
        $real_bind_options = ['ssl', 'crt', $cert_path, $ciphers]
      } else {
        $real_bind_options = undef
        warning('SSL enabled for haproxy dashboard frontend but no bind_options were specified. Add ssl crt /etc/ssl/keys/aptira_wc.key')
      }
    }

    haproxy::listen { 'dashboard':
      ipaddress        => $vip,
      ports            => ['443'],
      mode             => $listen_mode,
      collect_exported => false,
      options          => $listen_options,
      bind_options     => $real_bind_options
    }

    haproxy::listen { 'dashboard-http':
      ipaddress        => $vip,
      ports            => ['80'],
      collect_exported => false,
      options          => {
        'redirect' => 'scheme https if !{ ssl_fc }'
      },
    }

    haproxy::balancermember { 'dashboard':
      listening_service => 'dashboard',
      ports             => ['80'],
      server_names      => $cluster_names,
      ipaddresses       => $cluster_addresses,
      options           => $balancer_options,
      define_cookies    => $balancer_cookie
    }
  } else {
    openstacklib::loadbalance::haproxy_service { 'dashboard':
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
