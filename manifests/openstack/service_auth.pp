# == Define: openstacklib::openstack::service_auth
#
# This type creates a service user, grants it the admin role
# and then creates service and endpoint entries in keystone.
# These are all wrapped by ensure_resource to prevent
# multiple regions from redefining duplicate service users.
#
# === Parameters:
#
#[*project*]
# (Required) The name of the project, eg 'nova'
# This is used for naming the service user
#
#[*public_ip*]
# (Required) The IP (or hostname) on which the public
# endpoints will be created
#
#[*private_ip*]
# (Required) The IP (or hostname) on which the admin
# and internal endpoints will be created
#
#[*password*]
# (Required) Password for the service user
#
#[*service*]
# (Required) The type of keystone service entry to create,
# for example for nova this would be 'compute'
#
#[*region*]
# (Required) The region for this service
#
#[*email*]
# (Required) The email for the service user
#
#[*public_port*]
# (Required) The port for the public and internal service
# endpoint
#
#[*admin_port*]
# (Required) The port for the admin endpoint
#
#[*public_protocol*]
# (Required) The protocol to use for the public endpoint
#
#[*internal_protocol*]
# (Required) The protocol to use for the internal endpoint
#
#[*admin_protocol*]
# (Required) The protocol to use for the admin endpoint
#
#[*public_suffix*]
# (Optional) A string to be appended to the
# Internal and Public endpoints
# Defaults to ''
#
#[*admin_suffix*]
# (Optional) A string to be appended to the admin endpoint
# Defaults to ''
#
#[*tenant*]
# (Optional) Name of the service tenant. If false is used,
# no service user will be created (eg for keystone)
# Defaults to 'services'
#
define openstacklib::openstack::service_auth(
  $project,
  $public_ip,
  $private_ip,
  $password,
  $service,
  $region,
  $email,
  $public_port,
  $admin_port,
  $public_protocol,
  $internal_protocol,
  $admin_protocol,
  $public_suffix = '',
  $admin_suffix  = '',
  $tenant        = 'services',
) {

  if $tenant {
    ensure_resource( keystone_user, $project,
    {
      ensure   => present,
      password => $password,
      email    => $email,
      tenant   => $tenant
    })

    ensure_resource( keystone_user_role ,"${project}@${tenant}",
    {
      ensure => present,
      roles  => 'admin'
    })
  }

  ensure_resource( keystone_service, $service,
  {
    ensure      => present,
    type        => $service,
    description => "Openstack ${service} service"
  })

  ensure_resource( keystone_endpoint, "${region}/${service}",
  {
    ensure => present,
    public_url   => "${public_protocol}://${public_ip}:${public_port}${public_suffix}",
    internal_url => "${internal_protocol}://${private_ip}:${public_port}${public_suffix}",
    admin_url    => "${admin_protocol}://${private_ip}:${admin_port}${admin_suffix}"
  })
}
