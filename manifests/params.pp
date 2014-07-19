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

  $html_dir = '/var/cache/munin/www'
  $contacts = []
  $plugins = []

  $master_package_name = 'munin'
  $master_config_template = 'munin/etc/munin/munin.conf.erb'

  $node_package_name = 'munin-node'
  $node_service_name = 'munin-node'
  $node_config_template = 'munin/etc/munin/munin-node.conf.erb'
  $node_hostname = $::fqdn
  $node_timeout = 60
}
