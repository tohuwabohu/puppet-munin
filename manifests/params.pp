# Class: munin::params
#
# Default configuration for the munin class.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin::params {
  $ensure = installed
  $enable = true

  $contacts = []
  $plugins = []
  $disable_unmanaged_plugins = false

  $master_package_name = 'munin'
  $master_config_template = 'munin/etc/munin/munin.conf.erb'
  $master_html_dir = $::osfamily ? {
    default => '/var/cache/munin/www'
  }

  $node_package_name = 'munin-node'
  $node_service_name = 'munin-node'
  $node_config_template = 'munin/etc/munin/munin-node.conf.erb'
  $node_plugins_dir = $::osfamily ? {
    default => '/etc/munin/plugins'
  }
  $node_hostname = $::fqdn
  $node_timeout = 60
}
