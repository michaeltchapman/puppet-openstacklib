class openstacklib::firewall::glance(
  $source,
  $internal_source = undef,
  $glance_api = 9191,
  $glance_registry = 9292,
)
{
  firewall { "530 glance-registry accept tcp":
    proto => 'tcp',
    port   => [$glance_registry],
    action => accept,
    source => $source
  }

  firewall { "531 glance-api accept tcp":
    proto => 'tcp',
    port   => [$glance_api],
    action => accept,
    source => $source
  }
  if $internal_source {
    firewall { "530 glance-registry-internal accept tcp":
      proto => 'tcp',
      port   => [$glance_registry],
      action => accept,
      source => $internal_source
    }

    firewall { "531 glance-api-internal accept tcp":
      proto => 'tcp',
      port   => [$glance_api],
      action => accept,
      source => $internal_source
    }
  }
}
