# == Class: openstacklib::openstack::endpoints
#
# This class Configures endpoints
# for the specified services
#
# === Parameters:
#
# [*enabled_services*]
#   (optional) List of services that should have endpoints created.
#   Accepts elements: cinder,glance,keystone,nova, network, and all.
#   Defaults to ['cinder', 'glance', 'keystone', 'nova', 'neutron']
#
class openstacklib::openstack::endpoints (
  $enabled_services = [
    'cinder', 'glance', 'keystone', 'nova', 'neutron'
  ],
) {

  # keystone needs auth set up, but does not follow the
  # convention of the other services
  $real_enabled_services = delete($enabled_services, 'keystone')

  openstacklib::openstack::keystone_endpoint { $real_enabled_services: }

  include ::keystone::endpoint
  include ::keystone::roles::admin
}
