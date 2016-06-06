require 'spec_helper_acceptance'

describe 'activemq' do

  context 'with default parameters' do
    it_should_behave_like 'activemq::installed', ""
    it_should_behave_like 'activemq::running'
  end
end
