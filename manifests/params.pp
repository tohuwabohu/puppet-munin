class munin_standalone::params {
  $hostname = 'localhost.localdomain'
  $html_dir = '/var/cache/munin/www'
  $contacts = []
  $munin_conf_template = 'munin_standalone/munin.conf.erb'
  $munin_node_conf_template = 'munin_standalone/munin-node.conf.erb'
}