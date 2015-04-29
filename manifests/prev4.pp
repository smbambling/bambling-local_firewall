# == Class: local_firewall::prev4
#
# 'Common' IPv4 pre local firewall rules 
#
# === Authors
#
# Steven Bambling <smbambling@gmail.com>
#
# === Copyright
#
class local_firewall::prev4 {

  # Set this as a private class not to be called directly
  if is_function_available('assert_private') {
    assert_private()
  } else {
    private()
  }

  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp (v4)':
    proto    => 'icmp',
    action   => 'accept',
  }->
  firewall { '001 accept all to lo interface (v4)':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
  }->
  firewall { '002 accept related established rules (v4)':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
  }->
  firewall { '003 allow SSH access (v4)':
    port     => '22',
    proto    => 'tcp',
    action   => 'accept',
  }

}
