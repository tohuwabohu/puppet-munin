define munin::plugin($owner = 'root', $group = 'root') {
  file { "/etc/munin/plugins/${name}":
    ensure => 'link',
    target => "/usr/share/munin/plugins/${name}",
    owner  => $owner,
    group  => $group,
  }
}