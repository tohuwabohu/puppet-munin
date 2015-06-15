# = Class: munin::config
#
# Configure the munin installation.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class munin::config inherits munin {
  $file_ensure = $munin::ensure ? {
    /absent/ => absent,
    default  => file,
  }

  $directory_ensure = $munin::ensure ? {
    /absent/ => absent,
    default  => directory,
  }

  file { '/etc/munin/munin.conf':
    ensure  => $file_ensure,
    content => template($munin::master_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }

  file { '/etc/munin/munin-node.conf':
    ensure  => $file_ensure,
    content => template($munin::node_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }

  file { $munin::node_plugins_dir:
    ensure  => $directory_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    backup  => false,
    force   => true,
    recurse => true,
    purge   => $munin::disable_unmanaged_plugins,
  }
}
