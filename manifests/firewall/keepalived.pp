class openstacklib::firewall::keepalived(
) {

    firewall { "400 keepalived accept vrrp":
      proto => 'vrrp',
      action => accept,
    }
}
