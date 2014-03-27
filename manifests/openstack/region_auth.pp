# == Define: openstacklib::openstack::region_auth
#
# This defined type will create all the endpoints for
# the list of services passed in, with its title
# being the region. Shared services from another IP
# can also be specified, for example if the keystone
# and glance are shared amongst multiple regions
#
#[*public_ip*]
# (Required) The public IP for services in this region
#
#[*private_ip*]
# (Required) The private IP for services in this region
#
#[*services*]
# (Required) A list of services at the above IPs.
# Possible values: ['nova', 'keystone', 'heat', 'heat-cfn', 'cinder'
#                   'ceilometer', 'glance', 'neutron', 'ec2']
#
#[*admin_email*]
# (Required) The email address for the service users
#
#[*shared*]
# (Required) A mapping with a list of services at the shared IPs and
# the two shared IPs. For example:
# shared = {
#  'public_ip' => '10.0.0.1',
#  'private_ip' => '10.1.0.1',
#  'services'   => ['keystone','glance'] }
#
#[*tenant*]
# (optional) The tenant for the service users
# Defaults to 'services'
#
#[*public_protocol*]
# (Optional) The protocol for the public endpoint
# Defaults to 'http'
#
#[*internal_protocol*]
# (Optional) The protocol for the internal endpoint
# Defaults to 'http'
#
#[*admin_protocol*]
# (Optional) The protocol for the admin endpoint
# Defaults to 'http'
#
#[*keystone_user_pw*]
# (Optional) The password for the keystone service user
# Defaults to 'password'
#
#[*nova_user_pw*]
# (Optional) The password for the nova service user
# Defaults to 'password'
#
#[*neutron_user_pw*]
# (Optional) The password for the nova service user
# Defaults to 'password'
#
#[*glance_user_pw*]
# (Optional) The password for the glance service user
# Defaults to 'password'
#
#[*heat_user_pw*]
# (Optional) The password for the heat service user
# Defaults to 'password'
#
#[*cinder_user_pw*]
# (Optional) The password for the cinder service user
# Defaults to 'password'
#
#[*ceilometer_user_pw*]
# (Optional) The password for the ceilometer service user
# Defaults to 'password'
#
define openstacklib::openstack::region_auth(
  $public_ip,
  $private_ip,
  $services,
  $admin_email,
  $shared,
  $tenant             = 'services',
  $public_protocol    = 'http',
  $internal_protocol  = 'http',
  $admin_protocol     = 'http',
  $keystone_user_pw   = 'password',
  $nova_user_pw       = 'password',
  $neutron_user_pw    = 'password',
  $glance_user_pw     = 'password',
  $heat_user_pw       = 'password',
  $cinder_user_pw     = 'password',
  $ceilometer_user_pw = 'password'
)
{
  if ($name != 'shared') {

    $shared_services = $shared['services']
    $shared_public_ip = $shared['public_ip']
    $shared_private_ip = $shared['private_ip']

    $all_services = concat($services, $shared_services)

    if ('keystone' in $all_services) {

      if ('keystone' in $shared_services) {
        $kepublic_ip = $shared_public_ip
        $keprivate_ip = $shared_private_ip
      } else {
        $kepublic_ip = $public_ip
        $keprivate_ip = $private_ip
      }

      service_auth { "${name}/keystone":
        public_ip         => $kepublic_ip,
        private_ip        => $keprivate_ip,
        password          => false,
        service           => 'identity',
        region            => $name,
        project           => 'keystone',
        email             => $admin_email,
        tenant            => false,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '/v2.0',
        admin_suffix      => '/v2.0',
        public_port       => '5000',
        admin_port        => '35357'
      }
    }

    if ('ceilometer' in $all_services) {

      if 'ceilometer' in $shared_services {
        $cepublic_ip = $shared_public_ip
        $ceprivate_ip = $shared_private_ip
      } else {
        $cepublic_ip = $public_ip
        $ceprivate_ip = $private_ip
      }

      if $ceilometer_user_pw == 'password' {
        warning('Using default password for ceilometer service user')
      }

      service_auth { "${name}/ceilometer":
        public_ip         => $cepublic_ip,
        private_ip        => $ceprivate_ip,
        password          => $ceilometer_user_pw,
        service           => 'metering',
        region            => $name,
        project           => 'ceilometer',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '',
        admin_suffix      => '',
        public_port       => '8777',
        admin_port        => '8777'
      }
    }

    if ('heat-cfn' in $all_services) {

      if 'heat-cfn' in $shared_services {
        $hcpublic_ip = $shared_public_ip
        $hcprivate_ip = $shared_private_ip
      } else {
        $hcpublic_ip = $public_ip
        $hcprivate_ip = $private_ip
      }

      if $heat_user_pw == 'password' {
        warning('Using default password for heat service user')
      }

      service_auth { "${name}/heat-cfn":
        public_ip         => $hcpublic_ip,
        private_ip        => $hcprivate_ip,
        password          => $heat_user_pw,
        service           => 'cloudformation',
        region            => $name,
        project           => 'heat',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '',
        admin_suffix      => '',
        public_port       => '8000',
        admin_port        => '8000'
      }
    }

    if ('heat' in $all_services) {

      if 'heat' in $shared_services {
        $hepublic_ip = $shared_public_ip
        $heprivate_ip = $shared_private_ip
      } else {
        $hepublic_ip = $public_ip
        $heprivate_ip = $private_ip
      }

      if $heat_user_pw == 'password' {
        warning('Using default password for heat service user')
      }

      service_auth { "${name}/heat":
        public_ip         => $hepublic_ip,
        private_ip        => $heprivate_ip,
        password          => $heat_user_pw,
        service           => 'orchestration',
        region            => $name,
        project           => 'heat',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '/v1/%(tenant_id)s',
        admin_suffix      => '/v1/%(tenant_id)s',
        public_port       => '8004',
        admin_port        => '8004'
      }
    }

    if ('neutron' in $all_services) {

      if 'neutron' in $shared_services {
        $nepublic_ip = $shared_public_ip
        $neprivate_ip = $shared_private_ip
      } else {
        $nepublic_ip = $public_ip
        $neprivate_ip = $private_ip
      }

      if $neutron_user_pw == 'password' {
        warning('Using default password for neutron service user')
      }

      service_auth { "${name}/neutron":
        public_ip         => $nepublic_ip,
        private_ip        => $neprivate_ip,
        password          => $neutron_user_pw,
        service           => 'network',
        region            => $name,
        project           => 'neutron',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '',
        admin_suffix      => '',
        public_port       => '9696',
        admin_port        => '9696'
      }
    }

    if ('cinder' in $all_services) {

      if 'cinder' in $shared_services {
        $cipublic_ip = $shared_public_ip
        $ciprivate_ip = $shared_private_ip
      } else {
        $cipublic_ip = $public_ip
        $ciprivate_ip = $private_ip
      }

      if $cinder_user_pw == 'password' {
        warning('Using default password for cinder service user')
      }

      service_auth { "${name}/cinder":
        public_ip         => $cipublic_ip,
        private_ip        => $ciprivate_ip,
        password          => $cinder_user_pw,
        service           => 'volume',
        region            => $name,
        project           => 'cinder',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '/v1/%(tenant_id)s',
        admin_suffix      => '/v1/%(tenant_id)s',
        public_port       => '8776',
        admin_port        => '8776'
      }
    }

    if ('glance' in $all_services) {

      if 'glance' in $shared_services {
        $glpublic_ip = $shared_public_ip
        $glprivate_ip = $shared_private_ip
      } else {
        $glpublic_ip = $public_ip
        $glprivate_ip = $private_ip
      }

      if $glance_user_pw == 'password' {
        warning('Using default password for glance service user')
      }

      service_auth { "${name}/glance":
        public_ip         => $glpublic_ip,
        private_ip        => $glprivate_ip,
        password          => $glance_user_pw,
        service           => 'image',
        region            => $name,
        project           => 'glance',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '',
        admin_suffix      => '',
        public_port       => '9292',
        admin_port        => '9292'
      }
    }

    if ('nova' in $all_services) {

      if 'nova' in $shared_services {
        $nopublic_ip = $shared_public_ip
        $noprivate_ip = $shared_private_ip
      } else {
        $nopublic_ip = $public_ip
        $noprivate_ip = $private_ip
      }

      if $nova_user_pw == 'password' {
        warning('Using default password for nova service user')
      }

      service_auth { "${name}/nova":
        public_ip         => $nopublic_ip,
        private_ip        => $noprivate_ip,
        password          => $nova_user_pw,
        service           => 'compute',
        region            => $name,
        project           => 'nova',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '/v2/%(tenant_id)s',
        admin_suffix      => '/v2/%(tenant_id)s',
        public_port       => '8774',
        admin_port        => '8774'
      }
    }

    if ('ec2' in $all_services) {

      if 'ec2' in $shared_services {
        $ecpublic_ip = $shared_public_ip
        $ecprivate_ip = $shared_private_ip
      } else {
        $ecpublic_ip = $public_ip
        $ecprivate_ip = $private_ip
      }

      if $nova_user_pw == 'password' {
        warning('Using default password for nova service user')
      }

      service_auth { "${name}/ec2":
        public_ip         => $ecpublic_ip,
        private_ip        => $ecprivate_ip,
        password          => $nova_user_pw,
        service           => 'ec2',
        region            => $name,
        project           => 'nova',
        email             => $admin_email,
        tenant            => $tenant,
        public_protocol   => $public_protocol,
        internal_protocol => $internal_protocol,
        admin_protocol    => $admin_protocol,
        public_suffix     => '/services/Cloud',
        admin_suffix      => '/services/Admin',
        public_port       => '8773',
        admin_port        => '8773'
      }
    }
  }
}
