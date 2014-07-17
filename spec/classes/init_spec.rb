require 'spec_helper'

describe 'munin' do
  let(:title) { 'munin' }

  describe 'by default' do
    let(:params) { { } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file('/etc/munin/munin-node.conf') }
    specify { should contain_package('munin').with_ensure('latest') }
    specify { should contain_package('munin-node').with_ensure('latest') }
    specify { should contain_service('munin-node').with_ensure('running') }
  end

  describe 'with version => 1.0.0' do
    let(:params) { {:version => '1.0.0' } }

    specify { should contain_package('munin').with_ensure('1.0.0') }
    specify { should contain_package('munin-node').with_ensure('1.0.0') }
  end

  describe 'with disable => true' do
    let(:params) { {:disable => true } }

    specify { should contain_file('/etc/munin/munin.conf') }
    specify { should contain_file('/etc/munin/munin-node.conf') }
    specify { should contain_package('munin').with_ensure('latest') }
    specify { should contain_package('munin-node').with_ensure('latest') }
    specify { should contain_service('munin-node').with_ensure('stopped').with_enable(false) }
  end

  describe 'with plugins => [pluginA, pluginB]' do
    let(:params) { {:plugins => ['pluginA', 'pluginB'] } }

    specify { should contain_munin__plugin('pluginA') }
    specify { should contain_munin__plugin('pluginB') }
  end
end
