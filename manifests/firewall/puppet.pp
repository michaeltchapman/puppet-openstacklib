class openstacklib::firewall::puppet(
  $source,
  $puppet_master = 8140,
)
{
    firewall { "400 puppet-master accept tcp":
      proto => 'tcp',
      port   => [$puppet_master],
      action => accept,
      source => $source
    }
}
