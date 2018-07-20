require 'spec_helper'

describe 'activemq' do

  context 'when activemq is running' do
    describe service('activemq') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8161) do
      sleep 15
      it { should be_listening }
    end

    describe port(5432) do
      it { should be_listening }
    end
  end

  context 'when activemq-security-plugin installed and configured' do
    describe package('activemq-security-plugin') do
      it { should be_installed }
    end

    describe file('/opt/activemq/conf/activemq.xml') do
      its(:content) { should include '<bean id="tipaasSecurityPlugin" class="org.talend.ipaas.rt.amq.security.TipaasSecurityPlugin"' }
      its(:content) { should include '<property name="activemqSecurityURL" value="http://localhost:9999/activemq-security-service/authenticate' }
      its(:content) { should include '<property name="refreshInterval" value="60000" />' }
    end
  end

  describe user('activemq') do
    it { should exist }
    it { should belong_to_group 'activemq' }
  end

  describe group('activemq') do
    it { should exist }
  end

  describe file('/opt/activemq/conf/jetty-realm.properties') do
    its(:content) { should include 'testadmin: testpassword, admin' }
  end
end
