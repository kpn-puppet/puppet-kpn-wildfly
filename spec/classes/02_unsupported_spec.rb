require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly', :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on unsupported platforms' do
    UNSUPPORTED.each do |f|
      let(:facts) {f}
      describe "on #{f['os']['family']} #{f['os']['release']['major']}" do
        it { is_expected.to raise_error( Puppet::Error, /Module wildfly is not supported on/ )}
      end
    end
  end
end
