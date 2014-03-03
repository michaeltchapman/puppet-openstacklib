# == Class: openstacklib::firewall::dashboard
#
# Sets firewall rules for Dashboard
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*httpd_port*]
#   (optional) The port to open for httpd
#   Defaults to 80
#
# [*memcached_port*]
#   (optional) The port to open for memcached
#   Defaults to 11211
#
class openstacklib::firewall::dashboard(
  $source,
  $httpd_port = 80,
  $memcached_port = 11211,
)
{
  firewall { "560 dashboard-httpd accept tcp":
    proto => 'tcp',
    port   => [$httpd_port],
    action => accept,
    source => $source
  }

  firewall { "561 dashboard-memcached accept tcp":
    proto => 'tcp',
    port   => [$memcached_port],
    action => accept,
    source => $source
  }
}
