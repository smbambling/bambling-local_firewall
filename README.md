# local_firewall

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manages the local firewall (IPTables) on systems.

## Module Description

This module utitilize the puppetlabs-firewall module and follows their recommened setup by creating a seperate 'wrapper' module.

Configures:
  - Basic allow rule set including SSH
  - Specific logging to aid in troubleshooting
  - Basic reject rule set for each protocol and a catch all

This module was written with the roles and profiles methodology in mind.

## Usage

This module was written with the roles and profiles methodology in mind.

Add the following to your 'common' or base' profile that is applied to all nodes

````
class { 'local_firewall':
  ensure => running,
}
````

In your application/technology stack profiles add a section simliar to below, to only
apply additional rules if the firewall has been enabled from your 'common' or 'base' profile.

````
if ( $::local_firewall::ensure == 'running' ) {
  firewall { '100 lo only for 10025:10026 (v4)':
    iniface => 'lo',
    proto   => 'tcp',
    action  => 'accept',
    port   => '10025-10026',
  }
}
````

## Reference


## Limitations

This module was only tested on CentOS 6.x but should not have any issue working on other OS's

## Development

## Release Notes/Contributors/Etc **Optional**
