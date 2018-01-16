require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly::instance', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
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
        it { is_expected.to contain_Wildfly__Instance__Dependencies('wildfly10') }
        it { is_expected.to contain_file('/opt/wildfly10/bin/standalone.conf').with(
          'ensure' => 'file',
          'owner' => 'wildfly',
          'group' => 'wildfly',
          'mode' => '0644',
        )}
        it { is_expected.to contain_Wildfly__User__Mgmt_user('puppet:/opt/wildfly10') }
        it { is_expected.to contain_Wildfly__User__User('puppet:ManagementRealm:/opt/wildfly10') }
        it { is_expected.to contain_File_line('/opt/wildfly10:puppet:ManagementRealm') }
      end
    end
  end
end
