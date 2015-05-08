require 'spec_helper'

describe 'munin::plugin' do
  let(:title) { 'pluginA' }
  let(:plugin_ref) { '/etc/munin/plugins/pluginA' }

  describe 'should create link to plugin' do
    specify 'creates link to plugin' do
      should contain_file(plugin_ref).with({
        'ensure' => 'link',
        'target' => '/usr/share/munin/plugins/pluginA',
        'owner'  => 'root',
        'group'  => 'root'
      })
    end
  end

  describe 'should delete link to plugin' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_file(plugin_ref).with_ensure('absent') }
  end

  describe 'should not accept invalid ensure' do
    let(:params) { {:ensure => 'invalid'} }

    specify do
      expect { should contain_file(plugin_ref) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'should accept custom target' do
    let(:params) { {:target => '/path/to/file'} }

    specify { should contain_file(plugin_ref).with_target('/path/to/file') }
  end

  describe 'should not accept invalid target' do
    let(:params) { {:target => 'invalid'} }

    specify do
      expect { should contain_file(plugin_ref) }.to raise_error(Puppet::Error, /"invalid" is not an absolute path/)
    end
  end

  describe 'should accept source_url' do
    let(:params) { {:source_url => 'http://example.com/foobar'} }

    specify { should contain_wget__fetch('http://example.com/foobar') }
  end
end
