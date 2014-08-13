# == Class: openstacklib::openstack::singleton
#
# This is a class for dealing with OpenStack services
# that don't scale at all. Rather than deal with passive
# HA via corosync/pacemaker, a cluster master must be
# manually nominated. By default this class will do nothing
# due to parameter defaults.
#
# === Parameters:
#
# [*cluster_master*]
# (Optional) The fqdn of the node that will run this
# service.
#
# [*service_title*]
# (Optional) The title of the service that will be
# only run on a single node
# Defaults to undef
#
class openstacklib::openstack::singleton(
  $cluster_master = $::fqdn,
  $service_title  = undef
) {
  if $::fqdn != $cluster_master {
    Service<| title == $service_title |> {
      ensure  => 'stopped',
      enable  => false
    }
  }
}
