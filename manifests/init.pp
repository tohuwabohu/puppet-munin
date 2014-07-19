# Class: munin
#
# Manages munin server and client on the same node.
#
# == Parameters
#
# [*ensure*]
#   What state the package should be in. Passed through to package resource.
#
# [*enable*]
#   Set to `false` to stop and disable any running service(s)
#
# [*hostname*]
#   Sets the hostname in the master's and node's configuration. Defaults to ::fqdn.
#
# [*contacts*]
#   An array of contact email address to be notified when a warn or
#   critical state has been reached.
#
# [*plugins*]
#   An array of plugins to be enabled.
#
# [*disable_unmanaged_plugins*]
#   Set to `true` to disable any plugin that is not managed by Puppet. Defaults to `false`.
#
# [*master_config_template*]
#   Template used for the master node configuration.
#
# [*master_html_dir*]
#   Sets the directory where munin writes the statistics.
#
# [*node_config_template*]
#   Template used for the node configuration.
#
# [*node_timeout*]
#   Sets the timeout in seconds the node service waits when collecting the results. Defaults to 60 seconds.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin (
  $ensure                    = $munin::params::ensure,
  $enable                    = $munin::params::enable,

  $hostname                  = $munin::params::hostname,
  $contacts                  = $munin::params::contacts,
  $plugins                   = $munin::params::plugins,
  $disable_unmanaged_plugins = $munin::params::disable_unmanaged_plugins,

  $master_config_template    = $munin::params::master_config_template,
  $master_html_dir           = $munin::params::master_html_dir,

  $node_config_template      = $munin::params::node_config_template,
  $node_timeout              = $munin::params::node_timeout,
) inherits munin::params {

  validate_string($ensure)
  validate_bool($enable)

  if empty($hostname) {
    fail('Class[Munin]: hostname must not be empty')
  }

  validate_array($contacts)
  validate_array($plugins)
  validate_bool($disable_unmanaged_plugins)

  if empty($master_config_template) {
    fail('Class[Munin]: master_config_template must not be empty')
  }

  validate_absolute_path($master_html_dir)

  if empty($node_config_template) {
    fail('Class[Munin]: node_config_template must not be empty')
  }

  if $node_timeout !~ /\d+/ {
    fail("Class[Munin]: node_timeout must match /\\d+/, got '${node_timeout}'")
  }

  class { 'munin::install': } ->
  class { 'munin::config': } ~>
  class { 'munin::service': }

  munin::plugin { $plugins: }
}
