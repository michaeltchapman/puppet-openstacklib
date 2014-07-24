# == Class: openstacklib::firewall::base
#
# Sets firewall rules for basic system functionality
# including loopback, icmp, and established connections
#
# [*related*]
#   (optional) Whether to create the related,established
#   firewall rule
#   Defaults to true
#
# [*loopback*]
#   (optional) Whether to create the loopback device
#   firewall rule
#   Defaults to true
#
# [*icmp*]
#   (optional) Whether to create the icmp
#   firewall rule
#   Defaults to true
#
# [*drop*]
#   (optional) Whether to drop all non-matching traffic
#   Defaults to true
#
class openstacklib::firewall::base(
  $related  = true,
  $loopback = true,
  $icmp     = true,
  $drop     = true
)
{
  firewall { '701 base-state accept':
    proto   => 'all',
    ctstate =>  ['RELATED', 'ESTABLISHED'],
    action  => 'accept'
  }

  firewall { '702 base-lo accept':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept'
  }

  firewall { '703 base-icmp accept':
    proto   => 'icmp',
    action  => 'accept'
  }

  firewall { '999 base-drop reject all':
    proto   => 'all',
    action  => 'drop',
    before  => undef
  }
}
