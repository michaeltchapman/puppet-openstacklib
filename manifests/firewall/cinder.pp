# == Class: openstacklib::firewall::cinder
#
# Sets firewall rules for cinder
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*cinder_api*]
#   (optional) The port to open for cinder_api
#   Defaults to 8776
#
class openstacklib::firewall::cinder(
  $source,
  $internal_source = undef,
  $cinder_api      = 8776,
)
{
  firewall { '520 cinder-api accept tcp':
    proto  => 'tcp',
    port   => [$cinder_api],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { '520 cinder-api-internal accept tcp':
      proto  => 'tcp',
      port   => [$cinder_api],
      action => accept,
      source => $internal_source
    }
  }
}
