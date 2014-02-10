# This class is used to massage compatibility between versions,
# so that the puppet modules can remain on master and move from
# release n - 1 to n after the release of n

class openstacklib::compat(
  $openstack_release = 'havana',
) {
  case $openstack_release {
    'havana': {
      if defined("keystone") {
        # Unsure exactly why this has to be included.
        include keystone
        keystone_config {
          'DEFAULT/bind_host': value => $keystone::public_bind_host;
        }
      }
    }
  }
}
