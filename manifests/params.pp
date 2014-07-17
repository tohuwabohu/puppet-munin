# Class: munin::params
#
# Default configuration for the munin class.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin::params {
  $hostname = $::fqdn
  $html_dir = '/var/cache/munin/www'
  $contacts = []
  $plugins = []
  $disable = false
  $timeout = 60
  $version = 'latest'

  $master_package_name = 'munin'
  $master_config_template = 'munin/munin.conf.erb'

  $node_package_name = 'munin-node'
  $node_config_template = 'munin/munin-node.conf.erb'

  $apache_config_template = 'munin/apache.conf.erb'
  $nginx_config_template = 'munin/nginx.conf.erb'

  $www_auth_realm = 'Restricted Area'
  $www_authorized_users = {}
  $www_htpasswd_template = 'munin/munin.htpasswd.erb'
  $www_server_admin = "webmaster@${::fqdn}"
  $www_server_name = "status.${::fqdn}"
  $www_ssl_certificate = undef
  $www_ssl_key = undef
  $www_user = 'www-data'
}
