# == Class: local_firewall
#
# Manages the Pre/Post local firewall rule sets
#
# === Examples
# - Included in your 'base' profile
#     class { 'local_firewall':
#       ensure => running,
#     }
#
# - Included in your applicaiton profiles
#     if ( $::local_firewall::ensure == 'running' ) {
#       firewall { '100 lo only for 10025:10026 (v4)':
#         iniface => 'lo',
#         proto   => 'tcp',
#         action  => 'accept',
#         port   => '10025-10026',
#       }
#     }
#
# === Authors
#
# Steven Bambling <smbambling@gmail.com>
#
# === Copyright
#
#
class local_firewall ( $ensure = running, $verbose_logging = false ) {

  # Verify true/false
  validate_bool($verbose_logging)

  # Verify ensure value is valid for ::firewall module
  case $ensure {
    /^(running|stopped)$/: {

      class { 'firewall':
        ensure => $ensure,
      }

      if ( $ensure == 'running' ) {
        # Purge rules if not managed
        resources { 'firewall':
          purge => true
        }

        Firewall {
          before  => [ Class['local_firewall::postv4'], Class['local_firewall::postv6'], ],
          require => [ Class['local_firewall::prev4'], Class['local_firewall::prev6'], ],
        }

        include local_firewall::prev4
        include local_firewall::prev6
        class { 'local_firewall::postv4':
          verbose_logging => $verbose_logging,
        }
        class { 'local_firewall::postv6':
          verbose_logging => $verbose_logging,
        }
      }

    }
    default: {
      fail("${title}: Ensure value '${ensure}' is not supported")
    }
  }
}
