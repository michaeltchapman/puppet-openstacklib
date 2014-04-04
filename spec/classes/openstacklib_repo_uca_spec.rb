require 'spec_helper'

describe 'openstacklib::repo::uca' do

  describe 'Ubuntu with defaults' do

    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistdescription     => 'Ubuntu 12.04.1 LTS',
        :lsbdistcodename        => 'precise',
        :lsbdistid              => 'ubuntu',
      }
    end
    it do
      should contain_apt__source('ubuntu-cloud-archive').with(
        :release => 'precise-updates/havana'
      )
    end
  end

  describe 'Ubuntu and grizzly' do
    let :params do
      { :release => 'grizzly', :repo => 'proposed' }
    end

    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistdescription     => 'Ubuntu 12.04.1 LTS',
        :lsbdistcodename        => 'precise',
        :lsbdistid              => 'ubuntu',
      }
    end

    it do
      should contain_apt__source('ubuntu-cloud-archive').with(
        :release => 'precise-proposed/grizzly'
      )
    end
  end

end
