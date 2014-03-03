# == Class: openstacklib::firewall::edeploy
#
# Sets firewall rules for edeploy
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*dhcp_port*]
#   (optional) The port to open for dhcp
#   Defaults to 53
#
# [*tftp_port*]
#   (optional) The port to open for tftp
#   Defaults to 69
#
# [*rsync_port*]
#   (optional) The port to open for rsync
#   Defaults to 873
#
# [*edeploy_port*]
#   (optional) The port to open for edeploy http services
#   Defaults to 80
#
class openstacklib::firewall::edeploy(
  $source,
  $dhcp_port    = 53,
  $tftp_port    = 69,
  $rsync_port   = 873,
  $edeploy_port = 80,
)
{
  if $dhcp_port {
    firewall { "401 edeploy-dhcp accept tcp":
      proto => 'udp',
      port   => [$dhcp_port],
      action => accept,
      source => $source
    }
  }

  if $tftp_port {
    firewall { "402 edeploy-tftp accept tcp":
      proto => 'tcp',
      port   => [$tftp_port],
      action => accept,
      source => $source
    }
  }

  if $edeploy_port {
    firewall { "403 edeploy-http accept tcp":
      proto => 'tcp',
      port   => [$edeploy_port],
      action => accept,
      source => $source
    }
  }

  if $rsync_port {
    firewall { "404 edeploy-rsync accept tcp":
      proto => 'tcp',
      port   => [$rsync_port],
      action => accept,
      source => $source
    }
  }
}
