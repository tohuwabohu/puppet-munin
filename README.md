#munin

##Overview

Provides a Munin master and node on one host including the web server configuration for Apache or nginx.

##Usage

Install and set up Munin with all default values.

```
class { 'munin': }
```

##Limitations

The module has been tested on the following operating systems. Testing and patches for other platforms are welcome.

* Debian Linux 6.0 (Squeeze)

[![Build Status](https://travis-ci.org/tohuwabohu/puppet-munin.png?branch=master)](https://travis-ci.org/tohuwabohu/puppet-munin)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
