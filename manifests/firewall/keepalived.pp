# == Class: openstacklib::firewall::keepalived
#
# Sets firewall rules for keepalived (allow all vrrp)
#
class openstacklib::firewall::keepalived(
) {

    firewall { '400 keepalived accept vrrp':
      proto  => 'vrrp',
      action => accept,
    }
}
