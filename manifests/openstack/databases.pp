#
# openstacklib::create_dbs
#
# ==Parameters
#
# [enabled_services]
# List of services that should have databases created.
# Accepts elements: cinder,glance,keystone,nova, network, and all.
#
class openstacklib::openstack::databases(
  $enabled_services = [
    'cinder', 'glance', 'keystone', 'nova', 'neutron'
  ],
  $db_type = 'mysql'
) {

# delete swift to be nice to users, b/c they may have it
# as one of their enabled_services
  $real_enabled_services = delete($enabled_services, 'swift')

  openstack_database { $real_enabled_services:
    db_type => $db_type,
  }

}

define openstack_database(
  $db_type = 'mysql',
) {

  include "::${name}::db::${db_type}"

}
