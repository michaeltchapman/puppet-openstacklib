# == Class: openstack::openstack::provider
#
# This class overrides the external ovs
# port to keep its IP
#
# === Parameters:
#
# [*interface*]
# (optional) The interface to use for provider network
# Defaults to undef
#
class openstacklib::openstack::provider(
  $interface = undef
)
{
  if $interface {
    Vs_port <| title == $interface |> {
      keep_ip => true
    }
  }
}
