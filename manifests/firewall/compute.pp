# == Class: openstacklib::firewall::nova
#
# Sets firewall rules for nova
#
# [*interface*]
#   (required) Interface to allow traffic on
#
class openstacklib::firewall::compute(
  $interface
)
{
  firewall { '518 nova_compute_guest accept any':
    proto  => 'all',
    action => accept,
    iniface => $interface
  }
}
