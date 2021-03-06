# == Class: openstacklib::hosts
#
# Puppet can be sensetive to the ordering in /etc/hosts as
# it can affect the fqdn fact. This class will add the control
# and build nodes as well as a fqdn line at the top, until
# a better solution is found using the host resource type.
#
# === Parameters:
#
# [*build_server_ip*]
#   (required) The IP address of the build server
#   on the deployment network
#
# [*cluster_hash*]
#   (required) A hash of hostnames to ip addresses
#   on the internal network. This is used for rabbitmq
#   which takes a list of hostnames for its cluster.
#
# [*domain*]
#   (required) The DNS domain of the deploy network
#
# [*mgmt_ip*]
#   (optional) IP address of this node
#   on the deployment netowrk
#   Defaults to $::ipaddress_eth1
#
# [*build_server_name*]
#   (optional) Hostname of the build-server
#   Defaults to 'build-server'
#
class openstacklib::hosts (
  $build_server_ip   = false,
  $cluster_hash      = false,
  $domain            = false,
  $mgmt_ip           = $::ipaddress_eth1,
  $build_server_name = 'build-server',
  $strict_ordering   = false
) {

  if $build_server_ip and $cluster_hash and $domain and $strict_ordering {
    file { '/etc/hosts':
      ensure  => present,
      owner   => root,
      group   => root,
      content => template('openstacklib/hosts.erb'),
    } -> Package<||>
  }

  if ($cluster_hash and ! $strict_ordering) {
    $hostnames = keys($cluster_hash)
    create_resources('host', $cluster_hash)
  }
}
