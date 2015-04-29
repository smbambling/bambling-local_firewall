# == Class: local_firewall::postv6
#
# 'Common' IPv6 post local firewall rules
#
# === Authors
#
# Steven Bambling <smbambling@gmail.com>
#
# === Copyright
#
class local_firewall::postv6 ( $verbose_logging = false ) {

  # Set this as a private class not to be called directly
  if is_function_available('assert_private') {
    assert_private()
  } else {
    private()
  }
  
  # Verify true/false
  validate_bool($verbose_logging)

  if ( $verbose_logging == true ) {
    # Log New and Established
    firewall { '990 log new (v6)':
      proto      => 'all',
      jump       => 'LOG',
      limit      => '1/hour',
      log_prefix => 'IP6Tables-New: ',
      state      => 'NEW',
      chain      => 'INPUT',
      provider   => 'ip6tables',
    }->
    firewall { '991 log established (v6)':
      proto      => 'all',
      jump       => 'LOG',
      limit      => '1/hour',
      log_prefix => 'IP6Tables-Established: ',
      state      => 'ESTABLISHED',
      chain      => 'INPUT',
      provider   => 'ip6tables',
      before     => Firewall['992 log udp dropped (v6)'],
    }
  }

  firewall { '992 log udp dropped (v6)':
    proto      => 'udp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IP6Tables-Rejected UDP: ',
    provider   => 'ip6tables',
  }->
  firewall { '993 drop udp (v6)':
    proto    => 'udp',
    reject   => 'icmp6-port-unreachable',
    action   => 'reject',
    provider => 'ip6tables',
  }->
  firewall { '994 log tcp dropped (v6)':
    proto      => 'tcp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IP6Tables-Rejected TCP: ',
    provider   => 'ip6tables',
  }->
  firewall { '995 drop tcp (v6)':
    proto    => 'tcp',
    reject   => 'tcp-reset',
    action   => 'reject',
    provider => 'ip6tables',
  }->
  firewall { '996 log icmp dropped (v6)':
    proto      => 'ipv6-icmp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IP6Tables-Rejected ICMP: ',
    provider   => 'ip6tables',
  }->
  firewall { '997 drop icmp (v6)':
    proto    => 'ipv6-icmp',
    action   => 'drop',
    provider => 'ip6tables',
  }->
  firewall { '998 log all dropped (v6)':
    proto      => 'all',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IP6Tables-Rejected: ',
    provider   => 'ip6tables',
  }->
  firewall { '999 drop all (v6)':
    proto    => 'all',
    action   => 'drop',
    provider => 'ip6tables',
    before   => undef,
  }

}
