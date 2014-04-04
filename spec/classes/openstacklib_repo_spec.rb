require 'spec_helper'

describe 'openstacklib::repo' do
  let :default_params do
    {
      :yum_base_mirror => 'http://mirror.aarnet.edu.au',
      :yum_epel_mirror => 'http://mirror.aarnet.edu.au'
    }
  end

  let :params do
    {}
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat'}
    end

    describe 'with default parameters' do
      let :params do
        {}.merge!(default_params)
      end

      it { should contain_class('openstacklib::repo::rdo') }
      it { should contain_class('openstacklib::repo::epel') }

      it { should contain_yumrepo('CentOS-Base')}
      it { should contain_yumrepo('CentOS-Updates')}
      it { should contain_yumrepo('CentOS-Extras')}
    end

    describe 'with proxy set' do
      let :params do
        { :yum_http_proxy => 'http://10.0.0.1:8000' }.merge!(default_params)
      end

      it { should contain_yumrepo('CentOS-Base').with(
        :proxy => 'http://10.0.0.1:8000'
      )}
      it { should contain_yumrepo('CentOS-Updates').with(
        :proxy => 'http://10.0.0.1:8000'
      )}
      it { should contain_yumrepo('CentOS-Extras').with(
        :proxy => 'http://10.0.0.1:8000'
      )}
    end

  end

  context 'on Debian platforms' do
    let :facts do
    {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistdescription     => 'Ubuntu 12.04.1 LTS',
        :lsbdistcodename        => 'precise',
        :lsbdistid              => 'ubuntu'
    }
    end

    describe 'with default parameters and no proxy set' do
      before do
        params.merge!(default_params)
      end

      it { should contain_class('openstacklib::repo::uca')}
      it { should_not contain_class('apt')}
    end

    describe 'with default parameters and proxy set' do
      let :params do
        default_params.merge!({ :apt_proxy_host => '192.168.0.1',
                                :apt_proxy_port => '8000'})
      end

      it { should contain_class('openstacklib::repo::uca') }
      it { should contain_class('apt') }
    end
  end
end

