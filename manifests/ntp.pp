# == Class: openstacklib::ntp
#
# Manage ntpdate package and update cron job.
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) Status for the ntp package
#   Defaults to 'installed'
#
# [*package_name*]
#   (optional) Name of the ntp package
#   Defaults to 'installed'
#
# [*minute*]
#   (optional)
#   Defaults to '*/30'.
#
# [*hour*]
#   (optional)
#   Defaults to '*'.
#
# [*monthday*]
#   (optional)
#   Defaults to '*'.
#
# [*month*]
#   (optional)
#   Defaults to '*'.
#
# [*weekday*]
#   (optional)
#   Defaults to '*'.
#
class openstacklib::ntp(
  $package_ensure = 'installed',
  $package_name   = 'ntpdate',
  $minute        = '*/30',
  $hour          = '*',
  $monthday      = '*',
  $month         = '*',
  $weekday       = '*',
  $ntp_pool      = undef,
) {

  package { $package_name:
    ensure => $package_ensure
  }

  cron { 'ntpdate':
    command     => "ntpdate -u ${ntp_pool}",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin',
    user        => 'root',
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Package[$package_name],

  }
}
