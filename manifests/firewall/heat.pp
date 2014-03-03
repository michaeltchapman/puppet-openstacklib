# == Class: openstacklib::firewall::heat
#
# Sets firewall rules for heat
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*heat_api*]
#   (optional) The port to open for heat api
#   Defaults to 8004
#
# [*heat_cf*]
#   (optional) The port to open for heat cloudformation api
#   Defaults to 8000
#
class openstacklib::firewall::heat(
  $source,
  $internal_source = undef,
  $heat_api        = 8004,
  $heat_cf         = 8000,
)
{
  firewall { "570 heat-api accept tcp":
    proto => 'tcp',
    port   => [$heat_api],
    action => accept,
    source => $source
  }

  firewall { "571 heat-cf accept tcp":
    proto => 'tcp',
    port   => [$heat_cf],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { "570 heat-api-internal accept tcp":
      proto => 'tcp',
      port   => [$heat_api],
      action => accept,
      source => $internal_source
    }

    firewall { "571 heat-cf-internal accept tcp":
      proto => 'tcp',
      port   => [$heat_cf],
      action => accept,
      source => $internal_source
    }
  }
}
