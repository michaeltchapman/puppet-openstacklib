# == Class: openstacklib::firewall::neutron
#
# Sets firewall rules for neutron
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*neutron_api*]
#   (optional) The port to open for neutron api
#   Defaults to 9696
#
class openstacklib::firewall::neutron(
  $source,
  $internal_source = undef,
  $neutron_api     = 9696,
)
{
  firewall { '550 neutron-api accept tcp':
    proto  => 'tcp',
    port   => [$neutron_api],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { '550 neutron-api-internal accept tcp':
      proto  => 'tcp',
      port   => [$neutron_api],
      action => accept,
      source => $internal_source
    }
  }
}
