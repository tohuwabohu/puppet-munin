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

    should do
      expect { should contain_file(plugin_ref) }.to raise_error(Puppet::Error, /ensure/)
    end
  end
end
