class munin (
  $hostname = params_lookup('hostname'),
  $html_dir = params_lookup('html_dir'),
  $contacts = params_lookup('contacts'),
  
  $master_config_template = params_lookup('master_config_template'),
  $node_config_template = params_lookup('node_config_template'),
  
  $apache_conf_template = params_lookup('apache_conf_template'),
  $nginx_conf_template = params_lookup('nginx_conf_template'),
  $passwd_conf_template = params_lookup('passwd_conf_template'),
  
  $www_auth_realm = params_lookup('www_auth_realm'),
  $www_authorized_users = params_lookup('www_authorized_users'),
  $www_server_admin = params_lookup('www_server_admin'),
  $www_server_name = params_lookup('www_server_name'),
  $www_ssl_certificate = params_lookup('www_ssl_certificate'),
  $www_ssl_key = params_lookup('www_ssl_key'),
  $www_user = params_lookup('www_user')
) inherits munin::params {

  $config_filename = '/etc/munin/munin.conf'
  $www_password_file = '/etc/munin/munin.htpasswd'  
  
  package { ['munin', 'munin-node']: ensure => latest }
  
  service { 'munin-node':
    ensure  => running,
    require => Package['munin-node'],
  }
  
  file { $config_filename:
    content => template($munin::master_config_template),
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
      group => $munin::www_user,
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
  
}