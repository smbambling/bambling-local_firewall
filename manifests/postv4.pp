# == Class: local_firewall::postv4
#
# 'Common' IPv4 post local firewall rules
#
# === Authors
#
# Steven Bambling <smbambling@gmail.com>
#
# === Copyright
#
class local_firewall::postv4 ( $verbose_logging = false ) {

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
    firewall { '990 log new (v4)':
      proto      => 'all',
      jump       => 'LOG',
      limit      => '1/hour',
      log_prefix => 'IPTables-New: ',
      state      => 'NEW',
      chain      => 'INPUT',
    }->
    firewall { '991 log established (v4)':
      proto      => 'all',
      jump       => 'LOG',
      limit      => '1/hour',
      log_prefix => 'IPTables-Established: ',
      state      => 'ESTABLISHED',
      chain      => 'INPUT',
      before     => Firewall['992 log udp dropped (v4)'],
    }
  }

  # Log and Drop 
  firewall { '992 log udp dropped (v4)':
    proto      => 'udp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IPTables-Rejected UDP: ',
  }->
  firewall { '993 drop udp (v4)':
    proto  => 'udp',
    reject => 'icmp-port-unreachable',
    action => 'reject',
  }->
  firewall { '994 log tcp dropped (v4)':
    proto      => 'tcp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IPTables-Rejected TCP: ',
  }->
  firewall { '995 drop tcp (v4)':
    proto  => 'tcp',
    reject => 'tcp-reset',
    action => 'reject',
  }->
  firewall { '996 log icmp dropped (v4)':
    proto      => 'icmp',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IPTables-Rejected ICMP: ',
  }->
  firewall { '997 drop icmp (v4)':
    proto  => 'icmp',
    action => 'drop',
  }->
  firewall { '998 log all dropped (v4)':
    proto      => 'all',
    jump       => 'LOG',
    limit      => '5/min',
    log_prefix => 'IPTables-Rejected: ',
  }->
  firewall { '999 drop all (v4)':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }

}
