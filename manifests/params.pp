class munin::params {
  $hostname = 'localhost.localdomain'
  $html_dir = '/var/cache/munin/www'
  $contacts = []
  
  $munin_conf_template = 'munin/munin.conf.erb'
  $munin_node_conf_template = 'munin/munin-node.conf.erb'
  $apache_conf_template = 'munin/apache.conf.erb'
  $passwd_conf_template = 'munin/munin.htpasswd.erb'
  $passwd_owner = 'root'
  $passwd_group = 'root'
  $passwd_mode = '0640'

  $www_auth_realm = 'munin'
  $www_server_admin = 'webmaster@localhost'
  $www_server_name = 'example.com'
  $www_users = {}
}