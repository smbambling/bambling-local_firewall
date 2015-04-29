require 'spec_helper'
describe 'local_firewall' do

  context 'with defaults for all parameters' do
    it { should contain_class('local_firewall') }
  end
end
