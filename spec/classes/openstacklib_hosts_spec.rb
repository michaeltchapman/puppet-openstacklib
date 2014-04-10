require 'spec_helper'

describe 'openstacklib::hosts' do
  let :params do
    {
      :build_server_ip   => '192.168.1.1',
      :cluster_hash      => { 
        'control1.private' => {
          'ip'  => '10.0.1.11',
        },
        'control2.private' => {
          'ip'  => '10.0.1.12',
        }
      },
      :domain            => 'domain.name',
      :mgmt_ip           => '192.168.1.11',
      :build_server_name => 'build-server',
      :strict_ordering   => 'true'
    }
  end

  context 'on a compute node with two control nodes' do
    before { params.merge!({}) }
    let(:node) { 'compute1.domain.name' }
    let(:facts) {{ :hostname => 'compute1', :domain => 'domain.name' }}

    it { should contain_file('/etc/hosts').with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root'
    ) }

    it { should contain_file('/etc/hosts').with_content(/192.168.1.11 compute1.domain.name compute1/ )}
    it { should contain_file('/etc/hosts').with_content(/192.168.1.1   build-server.domain.name   build-server/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.11 control1.private/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.12 control2.private/ )}
  end

  context 'on a control node with two control nodes' do
    before { params.merge!({:mgmt_ip => '192.168.1.50'}) }
    let(:node) { 'control1.domain.name' }
    let(:facts) {{ :hostname => 'control1', :domain => 'domain.name' }}

    it { should contain_file('/etc/hosts').with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root'
    ) }

    it { should contain_file('/etc/hosts').with_content(/192.168.1.50 control1.domain.name control1/ )}
    it { should contain_file('/etc/hosts').with_content(/192.168.1.1   build-server.domain.name   build-server/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.11 control1.private/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.12 control2.private/ )}
  end

  context 'on the build node with two control nodes' do
    before { params.merge!({:mgmt_ip => '192.168.1.1'}) }
    let(:node) { 'build-server.domain.name' }
    let(:facts) {{ :hostname => 'build-server', :domain => 'domain.name' }}

    it { should contain_file('/etc/hosts').with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root'
    ) }

    it { should contain_file('/etc/hosts').with_content(/192.168.1.1 build-server.domain.name build-server/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.11 control1.private/ )}
    it { should contain_file('/etc/hosts').with_content(/10.0.1.12 control2.private/ )}
  end

  context 'on the a node with nonstrict ordering' do
    before { params.merge!({:strict_ordering => false}) }

    it { should contain_host('control1.private').with(:ip => '10.0.1.11')}
    it { should contain_host('control2.private').with(:ip => '10.0.1.12')}
  end

end

