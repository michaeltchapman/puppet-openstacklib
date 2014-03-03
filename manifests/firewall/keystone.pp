# == Class: openstacklib::firewall::keystone
#
# Sets firewall rules for keystone
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*keystone_public*]
#   (optional) The port to open for keystone public api
#   Defaults to 5000
#
# [*keystone_admin*]
#   (optional) The port to open for keystone admin api
#   Defaults to 35357
#
class openstacklib::firewall::keystone(
  $source,
  $internal_source = undef,
  $keystone_public = 5000,
  $keystone_admin  = 35357,
)
{
  firewall { "540 keystone-admin-api accept tcp":
    proto => 'tcp',
    port   => [$keystone_admin],
    action => accept,
    source => $source
  }

  firewall { "541 keystone-public-api accept tcp":
    proto => 'tcp',
    port   => [$keystone_public],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { "540 keystone-admin-api-internal accept tcp":
      proto => 'tcp',
      port   => [$keystone_admin],
      action => accept,
      source => $internal_source
    }

    firewall { "541 keystone-public-api-internal accept tcp":
      proto => 'tcp',
      port   => [$keystone_public],
      action => accept,
      source => $internal_source
    }
  }
}
