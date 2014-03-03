require 'spec_helper'

describe 'openstacklib::hosts' do
  let :params do
    {
      :build_server_ip   => '192.168.1.1',
      :cluster_hash      => { 
        'control1' => '10.0.1.11',
        'control2' => '10.0.1.12'
      },
      :domain            => 'domain.name',
      :mgmt_ip           => '192.168.1.11',
      :build_server_name => 'build-server'
    }
  end

  context 'on a compute node with two control nodes' do
    #before { params.merge!() }
    let(:node) { 'compute1.domain.name' }
    let(:facts) {{ :hostname => 'compute1', :domain => 'domain.name' }}

    it { should contain_file('/etc/hosts').with_content(/192.168.1.11  compute1.domain.name compute1/ )}
  end
end

