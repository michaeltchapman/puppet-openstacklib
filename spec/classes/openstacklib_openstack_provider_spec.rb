require 'spec_helper'

describe 'openstacklib::openstack::provider' do

  context 'with defaults' do
    let :pre_condition do
     "vs_bridge { 'br-ex':
        ensure => present,
        external_ids => 'bridge-id=br-ex'
      } 
      vs_port { 'eth2':
         ensure => present,
         bridge => 'br-ex'
       }"
    end

    it { should_not contain_vs_port('eth2').with(
      :keep_ip => true 
    )}

  context 'when using a provider network' do
    let :pre_condition do
     "vs_bridge { 'br-ex':
        ensure => present,
        external_ids => 'bridge-id=br-ex'
      } 
      vs_port { 'eth2':
         ensure => present,
         bridge => 'br-ex'
       }"
    end
    let :params do 
      { :interface => 'eth2' }
    end

    it { should contain_vs_port('eth2').with(
      :keep_ip => true 
    )}
    end
  end
end
