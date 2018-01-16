require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly::service', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on supported platforms' do
    SUPPORTED.each do |f|
      let :pre_condition do
        'class { "wildfly": }'
      end
      let(:facts) {f}
      let(:title) { 'wildfly10' }
      context "on #{f['os']['family']} #{f['os']['release']['major']} with defaults" do
        let(:params) {{
          catalina_home: '/opt/wildfly10',
        }}
        it { is_expected.to contain_Wildfly__Service('wildfly10') }
        it { is_expected.to contain_file('/etc/wildfly').with(
          'ensure' => 'directory',
        )}
        it { is_expected.to contain_file('/opt/wildfly10/bin/launch.sh').with(
          'ensure' => 'file',
          'owner' => 'wildfly',
          'group' => 'wildfly',
          'mode' => '0755',
        )}
        it { is_expected.to contain_file('/etc/wildfly/wildfly10.conf').with(
          'ensure' => 'file',
          'owner' => 'wildfly',
          'group' => 'wildfly',
          'mode' => '0644',
        )}
        if f['os']['release']['major'] == '8'
          it { is_expected.to contain_file('servicefile wildfly10').with(
            'ensure' => 'file',
            'path' => '/etc/init.d/wildfly10',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0755',
          )}
        else
          it { is_expected.to contain_file('servicefile wildfly10').with(
            'ensure' => 'file',
            'path' => '/etc/systemd/system/wildfly10.service',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0755',
          )}
        end
        it { is_expected.to contain_service('wildfly10').with(
          'ensure' => 'running',
          'enable' => 'true',
        )}
      end
    end
  end
end
