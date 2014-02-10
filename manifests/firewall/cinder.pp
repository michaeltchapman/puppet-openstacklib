class openstacklib::firewall::cinder(
  $source,
  $internal_source = undef,
  $cinder_api      = 8776,
)
{
  firewall { "520 cinder-api accept tcp":
    proto => 'tcp',
    port   => [$cinder_api],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { "520 cinder-api-internal accept tcp":
      proto => 'tcp',
      port   => [$cinder_api],
      action => accept,
      source => $internal_source
    }
  }
}
