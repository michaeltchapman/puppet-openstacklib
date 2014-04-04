require 'spec_helper'

describe 'openstacklib::openstack::netns' do

  describe 'with network namespace support not present' do
    let :facts do
      { :netns_support => 'false'}
    end

    it { should contain_package('kernel') }
    it { should contain_package('iproute') }
    it { should contain_package('iputils') }
  end

  describe 'with network namespace support present' do
    let :facts do
      { :netns_support => 'true'}
    end

    it { should_not contain_package('kernel') }
    it { should_not contain_package('iproute') }
    it { should_not contain_package('iputils') }
  end

end
