#
# This class Configures endpoints
# for the specified services
#
class openstacklib::openstack::endpoints (
  $enabled_services = [
    'cinder', 'glance', 'keystone', 'nova', 'neutron'
  ],
) {

# keystone needs auth set up, but does not follow the
# convention of the other services
  $real_enabled_services = delete($enabled_services, 'keystone')

  keystone_endpoints { $real_enabled_services: }

  include ::keystone::endpoint
  include ::keystone::roles::admin

}

define keystone_endpoints() {

  include "::${name}::keystone::auth"

}
