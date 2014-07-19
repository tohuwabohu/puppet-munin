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
define munin::plugin(
  $owner = 'root',
  $group = 'root'
) {
  validate_string($owner)
  validate_string($group)

  file { "/etc/munin/plugins/${name}":
    ensure  => 'link',
    target  => "/usr/share/munin/plugins/${name}",
    owner   => $owner,
    group   => $group,
    require => Class['munin::install'],
    notify  => Class['munin::service'],
  }
}
