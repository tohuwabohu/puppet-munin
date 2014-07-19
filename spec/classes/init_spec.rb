require 'spec_helper'

describe 'munin' do
  let(:title) { 'munin' }
  let(:master_config_file) { '/etc/munin/munin.conf' }
  let(:node_config_file) { '/etc/munin/munin-node.conf' }
  let(:plugins_dir) { '/etc/munin/plugins' }
  let(:facts) { {:fqdn => 'node.example.com' } }

  describe 'by default' do
    let(:params) { { } }

    specify { should contain_file(master_config_file) }
    specify { should contain_file(master_config_file).with_content(/htmldir \/var\/cache\/munin\/www/) }
    specify { should contain_file(node_config_file) }
    specify { should contain_file(node_config_file).with_content(/host_name node.example.com/) }
    specify { should contain_file(node_config_file).with_content(/timeout 60/) }
    specify { should contain_file(plugins_dir).with ({
        'force'   => 'true',
        'recurse' => 'true',
        'purge'   => 'false'
      })
    }
    specify { should contain_package('munin').with_ensure('installed') }
    specify { should contain_package('munin-node').with_ensure('installed') }
    specify { should contain_service('munin-node').with_ensure('running') }
  end

  describe 'with ensure => 1.0.0' do
    let(:params) { {:ensure => '1.0.0' } }

    specify { should contain_package('munin').with_ensure('1.0.0') }
    specify { should contain_package('munin-node').with_ensure('1.0.0') }
  end

  describe 'with ensure => absent' do
    let(:params) { {:ensure => 'absent' } }

    specify { should contain_file(master_config_file).with_ensure('absent') }
    specify { should contain_file(node_config_file).with_ensure('absent') }
    specify { should contain_file(plugins_dir).with_ensure('absent') }
    specify { should contain_package('munin').with_ensure('absent') }
    specify { should contain_package('munin-node').with_ensure('absent') }
    specify { should_not contain_service('munin-node') }
  end

  describe 'with enable => false' do
    let(:params) { {:enable => false } }

    specify { should contain_file(master_config_file) }
    specify { should contain_file(node_config_file) }
    specify { should contain_package('munin') }
    specify { should contain_package('munin-node') }
    specify { should contain_service('munin-node').with_ensure('stopped').with_enable(false) }
  end

  describe 'should not accept empty master_config_template' do
    let(:params) { {:master_config_template => ''} }

    specify do
      expect { should contain_file(master_config_file) }.to raise_error(Puppet::Error, /master_config_template/)
    end
  end

  describe 'should not accept invalid master_html_dir' do
    let(:params) { {:master_html_dir => 'invalid'} }

    specify do
      expect { should contain_file(master_config_file) }.to raise_error(Puppet::Error, /"invalid" is not an absolute path/)
    end
  end

  describe 'should accept valid master_html_dir' do
    let(:params) { {:master_html_dir => '/path/to/dir'} }

    specify { should contain_file(master_config_file).with_content(/htmldir \/path\/to\/dir/) }
  end

  describe 'should not accept empty node_config_template' do
    let(:params) { {:node_config_template => ''} }

    specify do
      expect { should contain_file(node_config_file) }.to raise_error(Puppet::Error, /node_config_template/)
    end
  end

  describe 'should not accept empty node_hostname' do
    let(:params) { {:node_hostname => ''} }

    specify do
      expect { should contain_file(node_config_file) }.to raise_error(Puppet::Error, /node_hostname/)
    end
  end

  describe 'should accept custom node_hostname' do
    let(:params) { {:node_hostname => 'beaf.example.com'} }

    specify { should contain_file(node_config_file).with_content(/host_name beaf.example.com/) }
  end

  describe 'should not accept empty node_timeout' do
    let(:params) { {:node_timeout => ''} }

    specify do
      expect { should contain_file(node_config_file) }.to raise_error(Puppet::Error, /node_timeout/)
    end
  end

  describe 'should not accept invalid node_timeout' do
    let(:params) { {:node_timeout => 'invalid'} }

    specify do
      expect { should contain_file(node_config_file) }.to raise_error(Puppet::Error, /node_timeout/)
    end
  end

  describe 'should accept custom node_timeout' do
    let(:params) { {:node_timeout => 120} }

    specify { should contain_file(node_config_file).with_content(/timeout 120/) }
  end

  describe 'with plugins => [pluginA, pluginB]' do
    let(:params) { {:plugins => ['pluginA', 'pluginB'] } }

    specify { should contain_munin__plugin('pluginA') }
    specify { should contain_munin__plugin('pluginB') }
  end

  describe 'should purge disabled unmanaged plugins when told so' do
    let(:params) { {:disable_unmanaged_plugins => true} }

    specify { should contain_file(plugins_dir).with ({
        'force'   => 'true',
        'recurse' => 'true',
        'purge'   => 'true'
      })
    }
  end
end
