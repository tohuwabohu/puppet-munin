require 'spec_helper'

describe 'munin' do
  let(:title) { 'munin' }
  let(:node_conf_file) { '/etc/munin/munin-node.conf' }
  let(:facts) { {:fqdn => 'node.example.com' } }

  describe 'by default' do
    let(:params) { { } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file(node_conf_file) }
    specify { should contain_file(node_conf_file).with_content(/host_name node.example.com/) }
    specify { should contain_file(node_conf_file).with_content(/timeout 60/) }
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

    specify { should contain_file('/etc/munin/munin.conf').with_ensure('absent') }
    specify { should contain_file(node_conf_file).with_ensure('absent') }
    specify { should contain_package('munin').with_ensure('absent') }
    specify { should contain_package('munin-node').with_ensure('absent') }
    specify { should_not contain_service('munin-node') }
  end

  describe 'with enable => false' do
    let(:params) { {:enable => false } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file(node_conf_file) }
    specify { should contain_package('munin') }
    specify { should contain_package('munin-node') }
    specify { should contain_service('munin-node').with_ensure('stopped').with_enable(false) }
  end

  describe 'should not accept empty node_hostname' do
    let(:params) { {:node_hostname => ''} }

    specify do
      expect { should contain_file(node_conf_file) }.to raise_error(Puppet::Error, /node_hostname/)
    end
  end

  describe 'should accept custom node_hostname' do
    let(:params) { {:node_hostname => 'beaf.example.com'} }

    specify { should contain_file(node_conf_file).with_content(/host_name beaf.example.com/) }
  end

  describe 'should not accept empty node_timeout' do
    let(:params) { {:node_timeout => ''} }

    specify do
      expect { should contain_file(node_conf_file) }.to raise_error(Puppet::Error, /node_timeout/)
    end
  end

  describe 'should not accept invalid node_timeout' do
    let(:params) { {:node_timeout => 'invalid'} }

    specify do
      expect { should contain_file(node_conf_file) }.to raise_error(Puppet::Error, /node_timeout/)
    end
  end

  describe 'should accept custom node_timeout' do
    let(:params) { {:node_timeout => 120} }

    specify { should contain_file(node_conf_file).with_content(/timeout 120/) }
  end

  describe 'with plugins => [pluginA, pluginB]' do
    let(:params) { {:plugins => ['pluginA', 'pluginB'] } }

    specify { should contain_munin__plugin('pluginA') }
    specify { should contain_munin__plugin('pluginB') }
  end
end
