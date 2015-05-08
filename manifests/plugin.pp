# = Definition: munin::plugin
#
# Manage a Munin plugin.
#
# == Parameters
#
# [*ensure*]
#   What state the plugin should be in: either present or absent.
#
# [*source_url*]
#   URL where to download the plugin source code file from. Optional.
#
# [*target*]
#   Set the target file providing the plugin functionality. Use if plugin is not contained in the munin plugins
#   directory or the file doesn't match for other reasons.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
define munin::plugin(
  $ensure     = present,
  $source_url = undef,
  $target     = "/usr/share/munin/plugins/${title}",
) {
  if $ensure !~ /present|absent/ {
    fail("Munin::Plugin[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  validate_absolute_path($target)

  require munin::params

  $file_ensure = $ensure ? {
    /absent/ => absent,
    default  => link,
  }

  if !empty($source_url) {
    wget::fetch { $source_url:
      destination => "${munin::params::node_plugins_dir}/${title}",
      timeout     => 30,
    }
  }

  file { "${munin::params::node_plugins_dir}/${title}":
    ensure  => $file_ensure,
    target  => $target,
    owner   => 'root',
    group   => 'root',
    require => Class['munin::install'],
    notify  => Class['munin::service'],
  }
}
