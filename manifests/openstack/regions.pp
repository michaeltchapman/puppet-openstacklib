# == Class: openstacklib::openstack::regions
#
# This is a wrapper class for creating multiple regions
# in keystone, each with their own endpoints and service
# users.
#
# === Parameters:
#
# [*regions_hash*]
# (Required) A hash of the actual and shared regions, with their IPs
# and services. Example:
# regions_hash => {
#   'RegionOne' => {
#     'public_ip'  => '10.0.0.1',
#     'private_ip' => '10.1.0.1',
#     'services' => ['nova', 'cinder', 'neutron'],
#   }
#   'RegionTwo' => {
#     'public_ip'  => '11.0.0.1',
#     'private_ip' => '11.1.0.1',
#     'services' => ['nova', 'cinder', 'neutron'],
#   }
#   'shared' => {
#     'public_ip'  => '12.0.0.1',
#     'private_ip' => '12.1.0.1',
#     'services' => ['keystone', 'glance'],
#   }
# }
#
# [*keystone_user_pw*]
# (Optional) Password for keystone service user
# Defaults to 'password'
#
# [*nova_user_pw*]
# (Optional) Password for nova service user
# Defaults to 'password'
#
# [*neutron_user_pw*]
# (Optional) Password for neutron service user
# Defaults to 'password'
#
# [*glance_user_pw*]
# (Optional) Password for glance service user
# Defaults to 'password'
#
# [*heat_user_pw*]
# (Optional) Password for heat service user
# Defaults to 'password'
#
# [*cinder_user_pw*]
# (Optional) Password for cinder service user
# Defaults to 'password'
#
# [*ceilometer_user_pw*]
# (Optional) Password for ceilometer service user
# Defaults to 'password'
#
# [*admin_email*]
# (Optional) Email address for service tenants
# Defaults to 'openstack@localhost'
#
# [*public_protocol*]
# (Optional) Protocol for public endpoints
# Defaults to 'http'
#
# [*internal_protocol*]
# (Optional) Protocol for internal endpoints
# Defaults to 'http'
#
# [*admin_protocol*]
# (Optional) Protocol for admin endpoints
# Defaults to 'http'
#
# [*tenant*]
# (Optional) Tenant for service users
# Defaults to 'services'
#
class openstacklib::openstack::regions(
  $regions_hash,
  $keystone_user_pw     = 'password',
  $nova_user_pw         = 'password',
  $neutron_user_pw      = 'password',
  $glance_user_pw       = 'password',
  $heat_user_pw         = 'password',
  $cinder_user_pw       = 'password',
  $ceilometer_user_pw   = 'password',
  $admin_email          = 'openstack@localhost',
  $public_protocol      = 'http',
  $internal_protocol    = 'http',
  $admin_protocol       = 'http',
  $tenant               = 'services'
) {

  $defaults = {
    'admin_email'        => $admin_email,
    'tenant'             => $tenant,
    'public_protocol'    => $public_protocol,
    'internal_protocol'  => $internal_protocol,
    'admin_protocol'     => $admin_protocol,
    'shared'             => $regions_hash['shared'],
    'keystone_user_pw'   => $keystone_user_pw,
    'nova_user_pw'       => $nova_user_pw,
    'neutron_user_pw'    => $neutron_user_pw,
    'glance_user_pw'     => $glance_user_pw,
    'heat_user_pw'       => $heat_user_pw,
    'cinder_user_pw'     => $cinder_user_pw,
    'ceilometer_user_pw' => $ceilometer_user_pw,
  }

  create_resources(openstacklib::openstack::region_auth, $regions_hash, $defaults)
}
