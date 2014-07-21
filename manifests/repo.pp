# == Class: openstacklib::repo
#
# This repo sets up RDO and UCA repositories on
# the approriate platforms. It currently supports
# either Centos or Ubuntu.
#
# === Parameters:
#
# [*yum_http_proxy*]
#   (optional) URL of an http proxy to use for all yum repos if set.
#   Defaults to undef
#
# [*yum_base_mirror*]
#   (optional) Mirror to use for CentOS base repositories
#   Defaults to 'http://mirror.aarnet.edu.au'
#
# [*yum_epel_mirror*]
#   (optional) Mirror to use for EPEL repositories
#   Defaults to 'http://mirror.aarnet.edu.au'
#
# [*apt_proxy_host*]
#   (optional) Address or hostname of apt proxy if set
#   Defaults to undef
#
# [*apt_proxy_port*]
#   (optional) Port to use for apt proxy if set
#   Defaults to undef
#
class openstacklib::repo (
  $yum_http_proxy = undef,
  $yum_base_mirror = 'http://mirror.aarnet.edu.au',
  $yum_epel_mirror = 'http://mirror.aarnet.edu.au',
  $apt_proxy_host = undef,
  $apt_proxy_port = undef,
) {
  if $::osfamily == 'Debian' {
    include openstacklib::repo::uca

      if $apt_proxy_host {
        include apt
      }
  }

  if $::osfamily == 'RedHat' {
      include openstacklib::repo::rdo
      include openstacklib::repo::epel

      if $yum_epel_mirror {
        Yumrepo<| title == 'epel' |> {
          baseurl => "${yum_epel_mirror}/\$releasever/\$basearch",
          mirrorlist => absent
        }
      }

      if $yum_http_proxy {
        Yumrepo<||> {
          proxy => $yum_http_proxy
        }
      }

      Yumrepo<||> -> Package<||>

      # Manage base repos via puppet so we can have proxy and mirror settings
      # will need to add proper rhel support
      Yumrepo {
        gpgcheck       => '1',
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
        enabled        => '1',
        mirrorlist     => absent
      }

      yumrepo {
        'CentOS-Base':
          descr          => 'CentOS-$releasever - Base',
          baseurl        => "${yum_base_mirror}/\$releasever/os/\$basearch/";
        'CentOS-Updates':
          descr          => 'CentOS-$releasever - Updates',
          baseurl        => "${yum_base_mirror}/\$releasever/updates/\$basearch/";
        'CentOS-Extras':
          descr          => 'CentOS-$releasever - Extras',
          baseurl        => "${yum_base_mirror}/\$releasever/extras/\$basearch/";
      }
  }
}
