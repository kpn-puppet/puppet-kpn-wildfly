require 'spec_helper'
require_relative '../versions.rb'

describe 'wildfly', :unless => RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/ do
  context '# Test module on supported platforms' do
    SUPPORTED.each do |f|
      let(:facts) {f}
      describe "on #{f['os']['family']} #{f['os']['release']['major']} with defaults" do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('wildfly') }
      end
    end
  end
end
