class openstacklib::firewall::dashboard(
  $source,
  $httpd_port = 80,
  $memcached_port = 11211,
)
{
  firewall { "560 dashboard-httpd accept tcp":
    proto => 'tcp',
    port   => [$httpd_port],
    action => accept,
    source => $source
  }

  firewall { "561 dashboard-memcached accept tcp":
    proto => 'tcp',
    port   => [$memcached_port],
    action => accept,
    source => $source
  }
}
