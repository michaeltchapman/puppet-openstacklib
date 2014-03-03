# == Class: openstacklib::firewall
#
# This class does nothing other than
# ensuring all firewall rules are applied
# before services are managed.
#
class openstacklib::firewall {
    Firewall <||> -> Service <||>
}
