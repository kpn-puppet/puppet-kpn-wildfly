require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly::config::module', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on supported platforms' do
    SUPPORTED.each do |f|
      let :pre_condition do
        'class { "wildfly": }'
      end
      let(:facts) {f}
      let(:title) { 'org.postgresql:/opt/wildfly10' }
      context "on #{f['os']['family']} #{f['os']['release']['major']} with defaults" do
        let(:params) {{
          source: 'https://jdbc.postgresql.org/download/postgresql-42.1.4.jar',
          checksum: '4523ed32e9245e762e1df9f0942a147bece06561770a9195db093d9802297735',
        }}
        it { is_expected.to contain_exec('Create Parent Directories: org.postgresql for /opt/wildfly10') }
        it { is_expected.to contain_file('/opt/wildfly10/modules/system/layers/base/org/postgresql/main') }
        it { is_expected.to contain_file('/opt/wildfly10/modules/system/layers/base/org/postgresql/main/module.xml') }
        it { is_expected.to contain_archive('/opt/wildfly10/modules/system/layers/base/org/postgresql/main/postgresql-42.1.4-jdbc42.jar') }
        it { is_expected.to contain_file('/opt/wildfly10/modules/system/layers/base/org/postgresql/main/postgresql-42.1.4-jdbc42.jar').that_subscribes_to('Archive[/opt/wildfly10/modules/system/layers/base/org/postgresql/main/postgresql-42.1.4-jdbc42.jar]') }
      end
    end
  end
end

describe 'wildfly::datasources::driver', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on supported platforms' do
    SUPPORTED.each do |f|
      let :pre_condition do
        'class { "wildfly": }'
      end
      let(:facts) {f}
      let(:title) { 'Driver postgresql:/opt/wildfly10' }
      context "on #{f['os']['family']} #{f['os']['release']['major']} with defaults" do
        let(:params) {{
          driver_name: 'postgresql',
          driver_module_name: 'org.postgresql',
          driver_xa_datasource_class_name: 'org.postgresql.xa.PGXADataSource',
        }}
        it { is_expected.to contain_Wildfly__Resource('/subsystem=datasources/jdbc-driver=postgresql:/opt/wildfly10') }
        it { is_expected.to contain_Wildfly_resource('/subsystem=datasources/jdbc-driver=postgresql/opt/wildfly10') }
      end
    end
  end
end

describe 'wildfly::datasources::datasource', :type => :define, :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on supported platforms' do
    SUPPORTED.each do |f|
      let :pre_condition do
        'class { "wildfly": }'
      end
      let(:facts) {f}
      let(:title) { 'DemoDS:/opt/wildfly10' }
      context "on #{f['os']['family']} #{f['os']['release']['major']} with defaults" do
        it { is_expected.to contain_Wildfly__Resource('/subsystem=datasources/data-source=DemoDS:/opt/wildfly10') }
        it { is_expected.to contain_Wildfly_resource('/subsystem=datasources/data-source=DemoDS/opt/wildfly10') }
        it { is_expected.to contain_Wildfly__Cli('Enable DemoDS for /opt/wildfly10') }
        it { is_expected.to contain_Wildfly_cli('Enable DemoDS for /opt/wildfly10') }
      end
    end
  end
end
