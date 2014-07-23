# == Class: openstacklib::firewall::memcached
#
# Sets firewall rules for memcached
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*memcached_port*]
#   (optional) The port to open for memcached
#   Defaults to 11211
#
class openstacklib::firewall::memcached(
  $source,
  $memcached_port = 11211,
)
{
  firewall { '561 dashboard-memcached accept tcp':
    proto  => 'tcp',
    port   => [$memcached_port],
    action => accept,
    source => $source
  }
}
