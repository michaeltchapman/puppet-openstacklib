class openstacklib::firewall::ceilometer(
  $source,
  $internal_source = undef,
  $ceilometer_api  = 8777,
)
{
  firewall { "580 ceilometer-api accept tcp":
    proto => 'tcp',
    port   => [$ceilometer_api],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { "580 ceilometer-api-internal accept tcp":
      proto => 'tcp',
      port   => [$ceilometer_api],
      action => accept,
      source => $internal_source
    }
  }
}
