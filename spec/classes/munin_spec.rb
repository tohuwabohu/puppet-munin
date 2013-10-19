require 'spec_helper'

describe 'munin' do
  let(:title) { 'munin' }

  describe 'standard installation' do
    let(:params) { { } }

    it { should contain_file('/etc/munin/munin.conf') }
    it { should contain_file('/etc/munin/munin-node.conf') }
    it { should contain_package('munin').with_ensure('latest') }
    it { should contain_package('munin-node').with_ensure('latest') }
    it { should contain_service('munin-node').with_ensure('running') }
  end

  describe 'custom version' do
    let(:params) { {:version => '1.0.0' } }

    it { should contain_package('munin').with_ensure('1.0.0') }
    it { should contain_package('munin-node').with_ensure('1.0.0') }
  end

  describe 'disable service' do
    let(:params) { {:disable => true } }

    it { should contain_file('/etc/munin/munin.conf') }
    it { should contain_file('/etc/munin/munin-node.conf') }
    it { should contain_package('munin').with_ensure('latest') }
    it { should contain_package('munin-node').with_ensure('latest') }
    it { should contain_service('munin-node').with_ensure('stopped').with_enable(false) }
  end

  describe 'manages plugins' do
    let(:params) { {:plugins => ['pluginA', 'pluginB'] } }

    it { should contain_munin__plugin('pluginA') }
    it { should contain_munin__plugin('pluginB') }
  end
end
