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
  $target     = undef,
) {
  if $ensure !~ /present|absent/ {
    fail("Munin::Plugin[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if !empty($target) {
    validate_absolute_path($target)
  }

  include munin

  $real_target = empty($target) ? {
    true    => empty($source_url) ? {
      true    => "/usr/share/munin/plugins/${title}",
      default => "${munin::node_plugins_local_install_dir}/${title}",
    },
    default => $target,
  }

  $file_ensure = $ensure ? {
    /absent/ => absent,
    default  => link,
  }

  if !empty($source_url) {
    wget::fetch { $source_url:
      destination => $real_target,
      timeout     => 30,
      require     => File[$munin::node_plugins_local_install_dir],
    }

    file { $real_target:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Wget::Fetch[$source_url],
    }
  }

  file { "${munin::node_plugins_dir}/${title}":
    ensure  => $file_ensure,
    target  => $real_target,
    owner   => 'root',
    group   => 'root',
    require => Class['munin::install'],
    notify  => Class['munin::service'],
  }
}
