class openstacklib::firewall::nova(
  $source,
  $internal_source = undef,
  $api_port        = 8774,
  $ec2_port        = 8773,
  $metadata_port   = 8775,
  $novnc_port      = 6080,
)
{
  firewall { "510 nova_api accept tcp":
    proto => 'tcp',
    port   => [$api_port],
    action => accept,
    source => $source
  }
  firewall { "511 nova_ec2 accept tcp":
    proto => 'tcp',
    port   => [$ec2_port],
    action => accept,
    source => $source
  }
  firewall { "512 nova_metadata accept tcp":
    proto => 'tcp',
    port   => [$metadata_port],
    action => accept,
    source => $source
  }
  firewall { "513 nova_novnc accept tcp":
    proto => 'tcp',
    port   => [$ec2_port],
    action => accept,
    source => $source
  }

  if $internal_source {
    firewall { "510 nova_api-internal accept tcp":
      proto => 'tcp',
      port   => [$api_port],
      action => accept,
      source => $internal_source
    }
    firewall { "511 nova_ec2-internal accept tcp":
      proto => 'tcp',
      port   => [$ec2_port],
      action => accept,
      source => $internal_source
    }
    firewall { "512 nova_metadata-internal accept tcp":
      proto => 'tcp',
      port   => [$metadata_port],
      action => accept,
      source => $internal_source
    }
    firewall { "513 nova_novnc-internal accept tcp":
      proto => 'tcp',
      port   => [$ec2_port],
      action => accept,
      source => $internal_source
    }
  }
}
