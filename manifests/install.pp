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
    $munin::master_package_name,
    $munin::node_package_name
  ]
  $local_install_dir = dirname($munin::node_plugins_local_install_dir)

  package { $packages:
    ensure => $munin::ensure
  }

  file { $local_install_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $munin::node_plugins_local_install_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
