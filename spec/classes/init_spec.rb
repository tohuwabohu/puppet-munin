require 'spec_helper'

describe 'munin' do
  let(:title) { 'munin' }

  describe 'by default' do
    let(:params) { { } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file('/etc/munin/munin-node.conf') }
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
    specify { should contain_file('/etc/munin/munin-node.conf').with_ensure('absent') }
    specify { should contain_package('munin').with_ensure('absent') }
    specify { should contain_package('munin-node').with_ensure('absent') }
    specify { should_not contain_service('munin-node') }
  end

  describe 'with enable => false' do
    let(:params) { {:enable => false } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file('/etc/munin/munin-node.conf') }
    specify { should contain_package('munin') }
    specify { should contain_package('munin-node') }
    specify { should contain_service('munin-node').with_ensure('stopped').with_enable(false) }
  end

  describe 'with plugins => [pluginA, pluginB]' do
    let(:params) { {:plugins => ['pluginA', 'pluginB'] } }

    specify { should contain_munin__plugin('pluginA') }
    specify { should contain_munin__plugin('pluginB') }
  end
end
