define munin::plugin($owner = 'root', $group = 'root', $mode = '0644') {
  file { "/etc/munin/plugins/${name}":
    ensure => 'link',
    target => "/usr/share/munin/plugins/${name}",
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}