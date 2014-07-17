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
  file { '/etc/munin/munin.conf':
    content => template($munin::master_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }
}
