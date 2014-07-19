# = Definition: munin::plugin
#
# An enabled munin plugin.
#
# == Parameters
#
# [*name*]
#   Sets the plugin name.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
define munin::plugin {
  file { "/etc/munin/plugins/${name}":
    ensure  => 'link',
    target  => "/usr/share/munin/plugins/${name}",
    owner   => 'root',
    group   => 'root',
    require => Class['munin::install'],
    notify  => Class['munin::service'],
  }
}
