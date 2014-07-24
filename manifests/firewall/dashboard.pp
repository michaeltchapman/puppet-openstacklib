# == Class: openstacklib::firewall::dashboard
#
# Sets firewall rules for Dashboard
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*httpd_port*]
#   (optional) The port to open for httpd
#   Defaults to 80
#
# [*https_port*]
#   (optional) The port to open for httpd
#   Defaults to 443
#
class openstacklib::firewall::dashboard(
  $source,
  $httpd_port     = 80,
  $https_port     = 443,
)
{
  firewall { '560 dashboard-http accept tcp':
    proto  => 'tcp',
    port   => [$httpd_port],
    action => accept,
    source => $source
  }

  firewall { '561 dashboard-https accept tcp':
    proto  => 'tcp',
    port   => [$https_port],
    action => accept,
    source => $source
  }
}
