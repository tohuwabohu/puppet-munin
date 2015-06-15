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
  $manage_service_enable = $munin::enable
  $manage_service_ensure = $munin::enable ? {
    false   => stopped,
    default => running,
  }

  if $munin::ensure !~ /absent/ {
    service { $munin::node_service_name:
      ensure  => $manage_service_ensure,
      enable  => $manage_service_enable,
    }
  }
}
