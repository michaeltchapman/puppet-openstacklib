require 'spec_helper'

describe 'openstacklib::openstack::regions' do
  let :pre_condition do
    "class { 'keystone::roles::admin':
       password => 'test',
       email    => 'blah@blah.com'
     }
    "
  end

  describe 'with two regions sharing keystone and glance' do
    let :params do
      {
        :regions_hash => {
          'RegionOne' => {
            'public_ip' => '10.2.3.5',
            'private_ip' => '10.3.3.5',
            'services' => ['nova','neutron','cinder']
          },
          'RegionTwo' => {
            'public_ip' => '11.2.3.5',
            'private_ip' => '11.3.3.5',
            'services' => ['nova','neutron','cinder']
          },
          'shared' => {
            'public_ip' => '12.2.3.5',
            'private_ip' => '12.3.3.5',
            'services' => ['keystone','glance']
          }
        }
      }
    end

    it { should contain_openstacklib__openstack__region_auth('RegionOne')}
    it { should contain_openstacklib__openstack__region_auth('RegionTwo')}
  end
end
