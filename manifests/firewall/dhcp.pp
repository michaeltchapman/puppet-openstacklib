+
# == Class: openstacklib::firewall::dhcp
#
# Sets firewall rules that are needed for dhcp
# agent in linuxbridge plugin mode to work
#
# [*linuxbridge_dhcp*]
#   (optional) If set to true, this will enable
#   this class and set permissive firewall options
#   allowing all udp traffic on ports 67 and 68
#   through the firewall.
#
class openstacklib::firewall::dhcp(
  $linuxbridge_dhcp = false
)
{
  if $linuxbridge_dhcp {
    firewall { '300 linuxbridge accept input dhcp':
      chain  => 'INPUT',
      proto  => 'udp',
      port   => ['67', '68'],
      action => accept,
    }

    firewall { '310 linuxbridge accept forward dhcp':
      chain  => 'FORWARD',
      proto  => 'udp',
      port   => ['67', '68'],
      action => accept,
    }
  }
}
