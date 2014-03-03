# == Class: openstacklib::firewall::rabbitmq
#
# Sets firewall rules for rabbitmq
#
# [*source*]
#   (required) Source CIDR to allow connections from
#
# [*internal_source*]
#   (optional) If set, additional source CIDR to allow
#   connections from. Use for internal endpoint.
#   Defaults to undef
#
# [*rabbit_port*]
#   (optional) The port to open for Rabbit AMQP connections
#   Defaults to 5672
#
# [*epmd_port*]
#   (optional) The port to open for epmd
#   Defaults to 4369
#
# [*erlang_upper*]
#   (optional) The beginning range to open for erlang
#   clustering
#   Defaults to 9100
#
# [*erlang_upper*]
#   (optional) The end of the range to open for erlang
#   clustering
#   Defaults to 9105
#
class openstacklib::firewall::rabbitmq(
  $source,
  $rabbit_port  = 5672,
  $epmd_port    = 4369,
  $erlang_lower = 9100,
  $erlang_upper = 9105,
)
{
    firewall { '500 rabbitmq_erlang accept tcp':
      proto  => 'tcp',
      dport  => ["${erlang_lower}-${erlang_upper}"],
      action => accept,
      source => $source
    }

    firewall { '501 rabbitmq_amqp accept tcp':
      proto  => 'tcp',
      port   => $rabbit_port,
      action => accept,
      source => $source
    }

    firewall { '500 rabbitmq_cluster accept tcp':
      proto  => 'tcp',
      port   => $epmd_port,
      action => accept,
      source => $source
    }
}
