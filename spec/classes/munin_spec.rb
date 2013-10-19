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
end
