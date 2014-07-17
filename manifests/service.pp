# = Class: munin::service
#
# Manage the munin service.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class munin::service inherits munin {
  $manage_service_ensure = $munin::disable ? {
    true    => 'stopped',
    default => 'running',
  }

  $manage_service_enable = $munin::disable ? {
    true    => false,
    default => true,
  }

  service { $munin::params::node_service_name:
    ensure  => $manage_service_ensure,
    enable  => $manage_service_enable,
  }
}
