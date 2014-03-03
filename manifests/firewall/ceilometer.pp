# == Class: openstacklib::firewall::ceilometer
#
# Sets firewall rules for Ceilometer
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*ceilometer_api*]
#   (optional) The port to open for ceilometer_api
#   Defaults to 8777
#
class openstacklib::firewall::ceilometer(
  $source,
  $internal_source = undef,
  $ceilometer_api  = 8777,
)
{
  firewall { '580 ceilometer-api accept tcp':
    proto  => 'tcp',
    port   => [$ceilometer_api],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { '580 ceilometer-api-internal accept tcp':
      proto  => 'tcp',
      port   => [$ceilometer_api],
      action => accept,
      source => $internal_source
    }
  }
}
