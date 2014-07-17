require 'spec_helper'

describe 'munin::plugin' do
  let(:title) { 'pluginA' }
  let(:params) { {:name => 'pluginA'} }

  specify 'creates link to plugin' do
    should contain_file('/etc/munin/plugins/pluginA').with({
      'ensure' => 'link',
      'target' => '/usr/share/munin/plugins/pluginA',
      'owner'  => 'root',
      'group'  => 'root',
    }) 
  end
end