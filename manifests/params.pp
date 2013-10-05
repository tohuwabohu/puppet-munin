class munin::params {
  $hostname = 'localhost.localdomain'
  $html_dir = '/var/cache/munin/www'
  $contacts = []
  $munin_conf_template = 'munin/munin.conf.erb'
  $munin_node_conf_template = 'munin/munin-node.conf.erb'
}