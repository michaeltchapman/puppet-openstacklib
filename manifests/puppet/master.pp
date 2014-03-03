# == Class openstacklib::puppet::master
#
# this class configures a machine
# as a puppetmaster.
#
# [*puppetlabs_repo*]
#   (optional) Sets the apt/yum repository from which
#   puppet master will be installed to be puppetlabs
#   Defaults to true
#
# [*puppet_master_address*]
#   (optional) the fqdn of the puppet master
#   Defaults to $::fqdn
#
class openstacklib::puppet::master (
  $puppetlabs_repo = true,
  $puppet_master_address = $::fqdn,
) {

  $puppet_master_bind_address = $puppet_master_address
# installs puppet
# I think I want to assume a puppet 3.x install

# if this is not set, make sure nodes are all pointing at an apt/yum repo
# that has puppet > 3.2
  if $puppetlabs_repo {
    include puppet::repo::puppetlabs
  }

  include apache

# the puppetdb package should not be installed
# before our certificate is generated
  Exec['Certificate_Check'] -> Package['puppetdb']

# we need to validate the puppetdb http connection
# and not the https one b/c will not have access to
# the certificate b/c we create it during the puppet
# run
  Service['puppetdb'] -> Puppetdb_conn_validator['puppetdb_conn_http']
  puppetdb_conn_validator { 'puppetdb_conn_http':
    ensure => present,
    puppetdb_server => $puppet_master_bind_address,
    puppetdb_port => 8080,
    use_ssl => false,
    timeout => 240,
    notify => Class['apache'],
  }

# install puppet master
  class { '::puppet::master':
    certname => $::fqdn,
    autosign => true,
    modulepath => '/etc/puppet/modules:/usr/share/puppet/modules',
  }

# install puppetdb and postgresql
  class { 'puppetdb':
    listen_address => $puppet_master_bind_address,
    ssl_listen_address => $puppet_master_bind_address,
    database_password => 'datapass',
    listen_port => 8080,
    ssl_listen_port => 8081
  }

  # I have no idea what this is but I get 403
  # on pluginsync without it
  #https://groups.google.com/forum/#!msg/puppet-users/eQpr0-zd3dM/cx8NwigZpBAJ
  if ($::osfamily == 'RedHat') {
    file { '/etc/puppet/auth.conf':
      owner => root,
      group => root,
      content => template('openstacklib/auth.conf.erb'),
      require => File[$::puppet::params::confdir],
      notify => Service[$::puppet::params::puppet_master_service],
    }
    file { '/etc/puppet/fileserver.conf':
      owner => root,
      group => root,
      content => template('openstacklib/fileserver.conf.erb'),
      require => File[$::puppet::params::confdir],
      notify => Service[$::puppet::params::puppet_master_service],
    }
  }

# Configure the puppet master to use puppetdb.
  class { 'puppetdb::master::config':
    puppetdb_server => $puppet_master_bind_address,
    puppetdb_port => 8081,
    restart_puppet => false,
# I only want to validate with http
    strict_validation => false,
  }
}
