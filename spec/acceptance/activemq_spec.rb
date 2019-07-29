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

    describe command('/bin/systemctl --no-pager show activemq.service') do
      its(:stdout) { should include 'LimitNOFILE=64000' }
      its(:stdout) { should include 'LimitNPROC=64000' }
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

  describe file('/opt/activemq/conf/activemq.xml') do
    its(:content) { should include '<!-- File managed by Puppet, do not modify-->' }
  end

  describe file('/opt/activemq/conf/jetty-server.xml') do
    its(:content) { should include '<!-- File managed by Puppet, do not modify-->' }
    its(:content) { should include '<Set name="minThreads">10</Set>' }
  end

  describe file('/opt/activemq/data/activemq.log') do
    its(:content) { should include 'Configuring Jetty server using /opt/activemq/conf/jetty-server.xml' }
  end

   describe command('/usr/bin/curl -s http://localhost:8080') do
     its(:exit_status) { should eq 0 }
     its(:stdout) { should include 'No clientID header specified' }
     its(:stdout) { should include 'Powered by Jetty' }
   end

   describe package('postgresql11') do
     it { should be_installed }
   end

end
