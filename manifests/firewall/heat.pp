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
