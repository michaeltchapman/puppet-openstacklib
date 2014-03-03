# == Class: openstacklib::firewall::puppet
#
# Sets firewall rules for puppet master
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*puppet_master*]
#   (optional) The port to open for puppet master
#   Defaults to 8140
#
class openstacklib::firewall::puppet(
  $source,
  $puppet_master = 8140,
)
{
    firewall { "400 puppet-master accept tcp":
      proto => 'tcp',
      port   => [$puppet_master],
      action => accept,
      source => $source
    }
}
