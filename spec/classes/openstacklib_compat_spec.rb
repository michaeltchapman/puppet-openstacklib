require 'spec_helper'

describe 'openstacklib::compat' do
  let :params do
    {
      :openstack_release => 'havana'
    }
  end

  let :pre_condition do
    "class { 'keystone':
       admin_token => 'test',
       public_bind_host   => '192.168.1.1'
     }"
  end

  context 'when installing havana using master branch' do
    it { should contain_keystone_config('DEFAULT/public_bind_host').with(
      :name  => 'DEFAULT/bind_host',
      :value => '192.168.1.1')}
  end
end
