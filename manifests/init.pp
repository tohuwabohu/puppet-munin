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
# [*apache_config_template*]
#   Template used for the apache configuration.
#
# [*nginx_config_template*]
#   Template used for the nginx configuration.
#
# [*www_auth_realm*]
#   Sets the authentication realm used in the HTTP configuration.
#
# [*www_authorized_users*]
#   A hash map of users with their password authorized to access the report page.
#
# [*www_htpasswd_template*]
#   Template used for the .htpasswd file.
#
# [*www_server_admin*]
#   Sets the email address of the server admin.
#
# [*www_server_name*]
#   Sets the domain name of the server.
#
# [*www_ssl_certificate*]
#   Sets the ssl certificate, the public key.
#
# [*www_ssl_key*]
#   Sets the ssl key, the private key.
#
# [*www_user*]
#   Sets the HTTP process.
#
# == Author
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
class munin (
  $hostname = params_lookup('hostname'),
  $html_dir = params_lookup('html_dir'),
  $contacts = params_lookup('contacts'),
  $plugins = params_lookup('plugins'),
  $timeout = params_lookup('timeout'),
  $disable = params_lookup('disable'),
  $version = params_lookup('version'),

  $master_config_template = params_lookup('master_config_template'),
  $node_config_template = params_lookup('node_config_template'),

  $apache_config_template = params_lookup('apache_config_template'),
  $nginx_config_template = params_lookup('nginx_config_template'),

  $www_auth_realm = params_lookup('www_auth_realm'),
  $www_authorized_users = params_lookup('www_authorized_users'),
  $www_htpasswd_template = params_lookup('www_htpasswd_template'),
  $www_server_admin = params_lookup('www_server_admin'),
  $www_server_name = params_lookup('www_server_name'),
  $www_ssl_certificate = params_lookup('www_ssl_certificate'),
  $www_ssl_key = params_lookup('www_ssl_key'),
  $www_user = params_lookup('www_user')
) inherits munin::params {

  $www_htpasswd_file = '/etc/munin/munin.htpasswd'
  $bool_disable = any2bool($disable)

  $manage_service_ensure = $munin::bool_disable ? {
    true    => 'stopped',
    default => 'running',
  }

  $manage_service_enable = $munin::bool_disable ? {
    true    => false,
    default => true,
  }

  package { ['munin', 'munin-node']: ensure => $munin::version }

  service { 'munin-node':
    ensure  => $manage_service_ensure,
    enable  => $manage_service_enable,
    require => Package['munin-node'],
  }

  file { '/etc/munin/munin.conf':
    content => template($munin::master_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }

  if $munin::www_ssl_certificate == undef or $munin::www_ssl_key == undef {
    $www_ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'
    $www_ssl_certificate_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  }
  else {
    $www_ssl_key_file = "/etc/ssl/private/${munin::www_server_name}.pem"
    $www_ssl_certificate_file = "/etc/ssl/certs/${munin::www_server_name}.pem"

    ssl::key { $www_ssl_key_file:
      key   => $munin::www_ssl_key,
      group => $munin::www_user,
    }

    ssl::certificate { $www_ssl_certificate_file:
      certificate => $munin::www_ssl_certificate,
    }
  }

  file { '/etc/munin/apache.conf':
    content => template($munin::apache_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }

  file { '/etc/munin/nginx.conf':
    content => template($munin::nginx_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }

  file { $munin::www_htpasswd_file:
    content => template($munin::www_htpasswd_template),
    owner   => 'root',
    group   => $munin::www_user,
    mode    => '0640',
    require => Package['munin'],
  }

  file { '/etc/munin/munin-node.conf':
    content => template($munin::node_config_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin-node'],
    notify  => Service['munin-node'],
  }

  munin::plugin { $plugins: }
}
