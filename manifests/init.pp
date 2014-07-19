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
# [*html_dir*]
#   Sets the directory where munin writes the statistics.
#
# [*contacts*]
#   An array of contact email address to be notified when a warn or
#   critical state has been reached.
#
# [*plugins*]
#   An array of plugins to be enabled.
#
# [*master_config_template*]
#   Template used for the master node configuration.
#
# [*node_config_template*]
#   Template used for the node configuration.
#
# [*node_hostname*]
#   Sets the hostname in the munin configuration.
#
# [*node_timeout*]
#   Sets the timeout in seconds the node service waits when collecting the results. Defaults to 60 seconds.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin (
  $ensure                 = $munin::params::ensure,
  $enable                 = $munin::params::enable,
  $html_dir               = $munin::params::html_dir,
  $contacts               = $munin::params::contacts,
  $plugins                = $munin::params::plugins,

  $master_config_template = $munin::params::master_config_template,
  $node_config_template   = $munin::params::node_config_template,
  $node_hostname          = $munin::params::node_hostname,
  $node_timeout           = $munin::params::node_timeout,
) inherits munin::params {

  validate_string($ensure)
  validate_bool($enable)
  validate_absolute_path($html_dir)
  validate_array($contacts)
  validate_array($plugins)
  validate_string($master_config_template)
  validate_string($node_config_template)
  if empty($node_hostname) {
    fail('Class[Munin]: node_hostname must not be empty')
  }

  if $node_timeout !~ /\d+/ {
    fail("Class[Munin]: node_timeout must match /\\d+/, got '${node_timeout}'")
  }

  class { 'munin::install': } ->
  class { 'munin::config': } ~>
  class { 'munin::service': }

  munin::plugin { $plugins: }
}
