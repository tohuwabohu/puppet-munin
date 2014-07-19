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
define munin::plugin($ensure = present) {
  if $ensure !~ /present|absent/ {
    fail("Munin::Plugin[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  $file_ensure = $ensure ? {
    /absent/ => absent,
    default  => link,
  }

  file { "/etc/munin/plugins/${name}":
    ensure  => $file_ensure,
    target  => "/usr/share/munin/plugins/${name}",
    owner   => 'root',
    group   => 'root',
    require => Class['munin::install'],
    notify  => Class['munin::service'],
  }
}
