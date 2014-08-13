# == Class: openstacklib::firewall::glance
#
# Sets firewall rules for glance
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*glance_api*]
#   (optional) The port to open for glance api
#   Defaults to 9191
#
# [*glance_registry*]
#   (optional) The port to open for glance registry
#   Defaults to 9292
#
class openstacklib::firewall::glance(
  $source,
  $internal_source = undef,
  $glance_api      = 9292,
  $glance_registry = 9191,
)
{
  firewall { '530 glance-registry accept tcp':
    proto  => 'tcp',
    port   => [$glance_registry],
    action => accept,
    source => $source
  }

  firewall { '531 glance-api accept tcp':
    proto  => 'tcp',
    port   => [$glance_api],
    action => accept,
    source => $source
  }
  if $internal_source {
    firewall { '530 glance-registry-internal accept tcp':
      proto  => 'tcp',
      port   => [$glance_registry],
      action => accept,
      source => $internal_source
    }

    firewall { '531 glance-api-internal accept tcp':
      proto  => 'tcp',
      port   => [$glance_api],
      action => accept,
      source => $internal_source
    }
  }
}
