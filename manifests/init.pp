class munin (
  $hostname = params_lookup('hostname'),
  $html_dir = params_lookup('html_dir'),
  $contacts = params_lookup('contacts'),
  $munin_conf_template = params_lookup('munin_conf_template'),
  $munin_node_conf_template = params_lookup('munin_node_conf_template'),
  $apache_conf_template = params_lookup('apache_conf_template'),
  $nginx_conf_template = params_lookup('nginx_conf_template'),
  $passwd_conf_template = params_lookup('passwd_conf_template'),
  $passwd_owner = params_lookup('passwd_owner'),
  $passwd_group = params_lookup('passwd_group'),
  $passwd_mode = params_lookup('passwd_mode'),
  $www_auth_realm = params_lookup('www_auth_realm'),
  $www_server_admin = params_lookup('www_server_admin'),
  $www_server_name = params_lookup('www_server_name'),
  $www_users = params_lookup('www_users'),
  $www_ssl_certificate = params_lookup('www_ssl_certificate'),
  $www_ssl_key = params_lookup('www_ssl_key')
) inherits munin::params {

  $config_filename = '/etc/munin/munin.conf'
  $www_password_file = '/etc/munin/munin.htpasswd'  
  
  package { ['munin', 'munin-node']: ensure => latest }
  
  service { 'munin-node':
    ensure  => running,
    require => Package['munin-node'],
  }
  
  file { $config_filename:
    content => template($munin_conf_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }
  
  if $www_ssl_certificate == undef or $www_ssl_key == undef {
    $www_ssl_key_file = "/etc/ssl/private/ssl-cert-snakeoil.key"
    $www_ssl_certificate_file = "/etc/ssl/ssl-cert-snakeoil.pem"
  }
  else {
    $www_ssl_key_file = "/etc/ssl/private/${munin::www_server_name}.pem"
    $www_ssl_certificate_file = "/etc/ssl/${munin::www_server_name}.pem"

    ssl::key { $www_ssl_key_file:
      key   => $www_ssl_key,
      group => 'www-data',
    }
    
    ssl::certificate { $www_ssl_certificate_file:
      certificate => $www_ssl_certificate,
    }
  }

  file { '/etc/munin/apache.conf':
    content => template($apache_conf_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }
  
  file { '/etc/munin/nginx.conf':
    content => template($nginx_conf_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }

  file { $www_password_file:
    content => template($passwd_conf_template),
    owner   => $passwd_owner,
    group   => $passwd_group,
    mode    => $passwd_mode,
    require => Package['munin'],
  }

  file { '/etc/munin/munin-node.conf':
    content => template($munin_node_conf_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin-node'],
    notify  => Service['munin-node'],
  }
  
}