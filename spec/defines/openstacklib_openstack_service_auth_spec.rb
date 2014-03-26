require 'spec_helper'

describe 'openstacklib::openstack::service_auth' do
  describe 'when defining a service without a user' do
    let :title do
      'regiontwo/keystone'
    end

    let :params do
    {
      :project           => 'keystone',
      :public_ip         => '10.2.3.5',
      :private_ip        => '10.3.3.5',
      :password          => 'test',
      :service           => 'identity',
      :region            => 'regiontwo',
      :email             => 'openstack@test',
      :public_port       => '5000',
      :admin_port        => '35357',
      :public_protocol   => 'https',
      :internal_protocol => 'http',
      :admin_protocol    => 'http',
      :public_suffix     => '',
      :admin_suffix      => '',
      :tenant            => false
    }
    end

    it { should_not contain_keystone_user('keystone') }

  end
  describe 'when defining a service' do
    let :title do
      'regiontwo/nova'
    end

    let :params do
    {
      :project           => 'nova',
      :public_ip         => '10.2.3.5',
      :private_ip        => '10.3.3.5',
      :password          => 'test',
      :service           => 'compute',
      :region            => 'regiontwo',
      :email             => 'openstack@test',
      :public_port       => '8774',
      :admin_port        => '8775',
      :public_protocol   => 'https',
      :internal_protocol => 'http',
      :admin_protocol    => 'http',
      :public_suffix     => '/v2/%(tenant)s',
      :admin_suffix      => '/v3/%(tenant)s',
      :tenant            => 'services'
    }
    end

    it { should contain_keystone_user('nova').with(
      :ensure => 'present',
      :password => 'test',
      :email    => 'openstack@test',
      :tenant   => 'services'
    )}

    it { should contain_keystone_user_role('nova@services').with(
      :ensure => 'present',
      :roles  => 'admin'
    )}

    it { should contain_keystone_service('compute').with(
      :ensure => 'present',
      :type   => 'compute'
    )}

    it { should contain_keystone_endpoint('regiontwo/compute').with(
      :ensure => 'present',
      :public_url => 'https://10.2.3.5:8774/v2/%(tenant)s',
      :internal_url => 'http://10.3.3.5:8774/v2/%(tenant)s',
      :admin_url => 'http://10.3.3.5:8775/v3/%(tenant)s'
    )}
  end
end
