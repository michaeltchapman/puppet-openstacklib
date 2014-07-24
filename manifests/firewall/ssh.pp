# == Class: openstacklib::firewall::ssh
#
# Sets firewall rules for ssh access
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*ssh_port*]
#   (optional) The port to open for ssh
#   Defaults to 22
#
class openstacklib::firewall::ssh(
  $source,
  $ssh_port = 22,
)
{
  firewall { '561 base-ssh accept tcp':
    proto  => 'tcp',
    port   => [$ssh_port],
    action => accept,
    source => $source
  }
}
