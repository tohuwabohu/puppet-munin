# Class: munin
#
# Manages munin server and client on the same node.
#
# == Parameters
#
# [*hostname*]
#   Sets the hostname in the munin configuration.
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
# [*timeout*]
#   Sets the timeout the node waits when collecting the results.
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#
# [*version*]
#   Sets the package version to install.
#
# [*master_config_template*]
#   Template used for the master node configuration.
#
# [*node_config_template*]
#   Template used for the node configuration.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin (
  $hostname               = $munin::params::hostname,
  $html_dir               = $munin::params::html_dir,
  $contacts               = $munin::params::contacts,
  $plugins                = $munin::params::plugins,
  $timeout                = $munin::params::timeout,
  $disable                = $munin::params::disable,
  $version                = $munin::params::version,

  $master_config_template = $munin::params::master_config_template,
  $node_config_template   = $munin::params::node_config_template,
) inherits munin::params {

  validate_string($hostname)
  validate_absolute_path($html_dir)
  validate_array($contacts)
  validate_array($plugins)
  validate_string($timeout)
  validate_bool($disable)
  validate_string($version)
  validate_string($master_config_template)
  validate_string($node_config_template)

  class { 'munin::install': } ->
  class { 'munin::config': } ~>
  class { 'munin::service': }

  munin::plugin { $plugins: }
}
