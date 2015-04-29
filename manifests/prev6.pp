# == Class: local_firewall::prev6
#
# 'Common' IPv6 pre local firewall rules 
#
# === Authors
#
# Steven Bambling <smbambling@gmail.com>
#
# === Copyright
#
class local_firewall::prev6 () {

  # Set this as a private class not to be called directly
  if is_function_available('assert_private') {
    assert_private()
  } else {
    private()
  }

  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp (v6)':
    proto    => 'ipv6-icmp',
    action   => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '001 accept all to lo interface (v6)':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '002 accept related established rules (v6)':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '003 allow SSH access (v6)':
    port     => '22',
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
  }

}
