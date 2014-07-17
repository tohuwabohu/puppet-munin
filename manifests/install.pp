# = Class: munin::install
#
# Install the munin package.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class munin::install inherits munin {
  $packages = [
    $munin::params::master_package_name,
    $munin::params::node_package_name
  ]

  package { $packages:
    ensure => $munin::ensure
  }
}
