require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly::install', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
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
          source: 'http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz',
          checksum: '80781609be387045273f974662dadf7f64ad43ee93395871429bc6b7786ec8bc',
        }}
        it { is_expected.to contain_Wildfly__Install__Source('wildfly10') }
        it { is_expected.to contain_user('wildfly').with(
          'ensure' => 'present',
          'gid'    => 'wildfly',
        )}
        it { is_expected.to contain_group('wildfly').with(
          'ensure' => 'present',
        )}
        it { is_expected.to contain_file('/opt/wildfly10').with(
          'ensure' => 'directory',
          'owner' => 'wildfly',
          'group' => 'wildfly',
        )}
        it { is_expected.to contain_archive('wildfly10-/opt/wildfly10/wildfly-10.1.0.Final.tar.gz').with(
          'source'         => 'http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz',
          'checksum'       => '80781609be387045273f974662dadf7f64ad43ee93395871429bc6b7786ec8bc',
          'extract_path'   => '/opt/wildfly10',
          'user'           => 'wildfly',
          'group'          => 'wildfly',
          'extract_flags'  => '--strip 1 -xf',
          'allow_insecure' => false,
        )}
      end
    end
  end
end
