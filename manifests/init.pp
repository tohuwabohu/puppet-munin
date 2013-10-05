class munin_standalone (
  $hostname = params_lookup('hostname'),
  $html_dir = params_lookup('html_dir'),
  $contacts = params_lookup('contacts'),
  $munin_conf_template = params_lookup('munin_conf_template'),
  $munin_node_conf_template = params_lookup('munin_node_conf_template'),
) inherits munin_standalone::params {
  
  package { ['munin', 'munin-node']: ensure => latest }
  
  service { 'munin-node':
    ensure  => running,
    require => Package['munin-node'],
  }
  
  file { '/etc/munin/munin.conf':
    content => template($munin_conf_template),
    require => Package['munin'],
  }
  
  file { '/etc/munin/munin-node.conf':
    content => template($munin_node_conf_template),
    require => Package['munin-node'],
    notify  => Service['munin-node'],
  }
}