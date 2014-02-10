class openstacklib::firewall::rabbitmq(
  $source,
  $rabbit_port  = 5672,
  $epmd_port    = 4369,
  $erlang_lower = 9100,
  $erlang_upper = 9105,
)
{
    firewall { "500 rabbitmq_erlang accept tcp":
      proto => 'tcp',
      dport => ["$erlang_lower-$erlang_upper"],
      action => accept,
      source => $source
    }

    firewall { "501 rabbitmq_amqp accept tcp":
      proto => 'tcp',
      port  => $rabbit_port,
      action => accept,
      source => $source
    }

    firewall { "500 rabbitmq_cluster accept tcp":
      proto => 'tcp',
      port   => $epmd_port,
      action => accept,
      source => $source
    }
}
