class munin::params {
  $hostname = 'localhost.localdomain'
  $html_dir = '/var/cache/munin/www'
  $contacts = []
  
  $munin_conf_template = 'munin/munin.conf.erb'
  $munin_node_conf_template = 'munin/munin-node.conf.erb'
  $apache_conf_template = 'munin/apache.conf.erb'
  $nginx_conf_template = 'munin/nginx.conf.erb'
  $passwd_conf_template = 'munin/munin.htpasswd.erb'

  $www_auth_realm = 'Restricted Area'
  $www_authorized_users = {}
  $www_server_admin = 'webmaster@localhost'
  $www_server_name = 'example.com'
  $www_ssl_certificate = undef
  $www_ssl_key = undef
  $www_user = 'www-data'
}