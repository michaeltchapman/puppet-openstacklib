# Puppet can be sensetive to the ordering in /etc/hosts as
# it can affect the fqdn fact. This class will add the control
# and build nodes as well as a fqdn line at the top, until
# a better solution is found using the host resource type.

class openstacklib::hosts (
  $build_server_ip,
  $cluster_hash,
  $domain,
  $mgmt_ip = $::ipaddress_eth1,
  $build_server_name = 'build-server',
) {

  file { '/etc/hosts':
    ensure => present,
    owner  => root,
    group  => root,
    content => template('openstacklib/hosts.erb'),
  } -> Package<||>
}
