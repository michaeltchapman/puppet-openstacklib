# == Class: openstacklib::compat::keystone
#
# This class is used to massage compatibility between versions,
# so that the puppet modules can remain on master and move from
# release n - 1 to n after the release of n
#
# === Parameters
#
# [*openstack_release*]
#   (optional) The version of openstack to be installed
#   Defaults to 'havana'
#
class openstacklib::compat::keystone(
  $openstack_release = 'havana',
) {
  case $openstack_release {
    'havana': {

      # Bind hosts were separated out to public/admin in icehouse
      Keystone_config <| title == 'DEFAULT/public_bind_host' |>  {
        name  => 'DEFAULT/bind_host',
        value => hiera('keystone::public_bind_host')
      }

      # Database section was moved from [sql] to [database] in icehouse
      Keystone_config <| title == 'database/connection' |> {
        name => 'sql/connection',
      }

      Keystone_config <| title == 'database/idle_timeout' |> {
        name => 'sql/idle_timeout',
      }
    }

    default: {
      notify { 'Nothing to do for compat class': }
    }
  }
}
