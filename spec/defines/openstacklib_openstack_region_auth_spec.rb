require 'spec_helper'

describe 'openstacklib::openstack::region_auth' do

  let :default_params do
  {
    :public_protocol    => 'http',
    :internal_protocol  => 'http',
    :admin_protocol     => 'http',
    :tenant             => 'services',
    :keystone_user_pw   => 'password',
    :nova_user_pw       => 'password',
    :neutron_user_pw    => 'password',
    :glance_user_pw     => 'password',
    :heat_user_pw       => 'password',
    :cinder_user_pw     => 'password',
    :ceilometer_user_pw => 'password'
  }
  end

  let :title do
    'regiontwo'
  end


  describe 'with default params and split keystone+glance' do
    let :params do
      default_params.merge!({
        :public_ip         => '10.2.3.5',
        :private_ip        => '10.3.3.5',
        :services          => ['nova', 'cinder', 'neutron'],
        :admin_email       => 'openstack@test',
        :shared            => {
          'public_ip'  => '11.2.3.5',
          'private_ip' => '11.3.3.5',
          'services'   => ['keystone', 'glance']
        }
      })
    end

    it { should contain_openstacklib__openstack__service_auth('regiontwo/keystone').with(
      :public_ip  => '11.2.3.5',
      :private_ip => '11.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/glance').with(
      :public_ip  => '11.2.3.5',
      :private_ip => '11.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/nova').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/cinder').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/neutron').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
  end

  describe 'with default params and one full region' do
    let :params do
      default_params.merge!({
        :public_ip         => '10.2.3.5',
        :private_ip        => '10.3.3.5',
        :services          => ['nova', 'cinder', 'neutron', 'keystone',
                               'glance', 'ec2', 'heat', 'heat-cfn',
                               'ceilometer'],
        :admin_email       => 'openstack@test',
        :shared            => {
          'public_ip'  => '0.0.0.0',
          'private_ip' => '0.0.0.0',
          'services'   => ['none']
        }
      })
    end

    it { should contain_openstacklib__openstack__service_auth('regiontwo/keystone').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/glance').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/nova').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/cinder').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/neutron').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/heat').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/heat-cfn').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/ceilometer').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
    it { should contain_openstacklib__openstack__service_auth('regiontwo/ec2').with(
      :public_ip  => '10.2.3.5',
      :private_ip => '10.3.3.5'
    )}
  end
end
