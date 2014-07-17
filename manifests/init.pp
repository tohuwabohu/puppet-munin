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
  $hostname               = $munin::params::hostname,
  $html_dir               = $munin::params::html_dir,
  $contacts               = $munin::params::contacts,
  $plugins                = $munin::params::plugins,
  $timeout                = $munin::params::timeout,
  $disable                = $munin::params::disable,
  $version                = $munin::params::version,

  $master_config_template = $munin::params::master_config_template,
  $node_config_template   = $munin::params::node_config_template,

  $apache_config_template = $munin::params::apache_config_template,
  $nginx_config_template  = $munin::params::nginx_config_template,

  $www_auth_realm         = $munin::params::www_auth_realm,
  $www_authorized_users   = $munin::params::www_authorized_users,
  $www_htpasswd_template  = $munin::params::www_htpasswd_template,
  $www_server_admin       = $munin::params::www_server_admin,
  $www_server_name        = $munin::params::www_server_name,
  $www_ssl_certificate    = $munin::params::www_ssl_certificate,
  $www_ssl_key            = $munin::params::www_ssl_key,
  $www_user               = $munin::params::www_user
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
  validate_string($apache_config_template)
  validate_string($nginx_config_template)
  validate_string($www_auth_realm)
  validate_hash($www_authorized_users)
  validate_string($www_htpasswd_template)
  $www_htpasswd_file = '/etc/munin/munin.htpasswd'
  validate_string($www_server_admin)
  validate_string($www_server_name)
  validate_string($www_ssl_certificate)
  validate_string($www_ssl_key)
  validate_string($www_user)

  class { 'munin::install': } ->
  class { 'munin::config': } ~>
  class { 'munin::service': }

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

  munin::plugin { $plugins: }
}
