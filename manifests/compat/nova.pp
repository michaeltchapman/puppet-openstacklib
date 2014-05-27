# == Class: openstacklib::compat::nova
#
# This class is used to massage compatibility between versions,
# so that the puppet modules can remain on master and move from
# release n - 1 to n after the release of n
#
# === Parameters
#
# [*openstack_release*]
#   (optional) The version of openstack to be installed
#   Defaults to 'havana'
#
class openstacklib::compat::nova(
  $openstack_release = 'havana',
) {
  case $openstack_release {
    'havana': {

      # libvirt has its own section as of icehouse
      Nova_config <| title == 'libvirt/virt_type' |> {
        name => 'DEFAULT/libvirt_type',
        value => hiera('nova::compute::libvirt::libvirt_virt_type')
      }
    }

    default: {
      notify { 'Nothing to do for compat class': }
    }
  }
}
