# == Class: openstacklib::openstack::databases
#
# Given a list of services and db type, this class will include
# the db class of the correct type from the service module
#
# == Parameters:
#
# [*enabled_services*]
#   (optional) List of services that should have databases created.
#   Accepts elements: cinder,glance,keystone,nova, network, and all.
#   Defaults to ['cinder', 'glance', 'keystone', 'nova', 'neutron']
#
# [*db_type*]
#   (optional) The type of db to use.
#   Valid options are 'mysql' and 'postgres'
#   Defaults to 'mysql'
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

  openstacklib::openstack::database { $real_enabled_services:
    db_type => $db_type,
  }
}
