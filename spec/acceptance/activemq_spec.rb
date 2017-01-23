require 'spec_helper'

describe 'activemq' do

  context 'when activemq is running' do
    describe service('activemq') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8161) do
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
      its(:content) { should include '<property name="refreshInterval" value="900000" />' }
    end
  end

  context 'when activemq-security-service ready' do
    describe command('/usr/bin/curl -u admin:password http://localhost:9999/activemq-security-service/authenticate') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should include 'destination' }
      its(:stdout) { should include 'queue' }
      its(:stdout) { should include 'ipaas' }
    end
  end

  context 'when accessed with proper credentials' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb admin password ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/ruby /tmp/stomp-consumer.rb admin password ipaas.testing.notification.manager.queue') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should include 'test_data' }
    end
  end

  context 'when accessed with wrong username' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb nonexistentuser password ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 1 }
    end
  end

  context 'when accessed with wrong password' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb admin wrongpassword ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 1 }
    end
  end

  context 'when trying to work with a wrong queue' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb admin password wrong.queue test_data') do
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/ruby /tmp/stomp-consumer.rb admin password wrong.queue') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should_not include 'test_data' }
    end

    describe file('/opt/activemq/data/activemq.log') do
      its(:content) { should include 'User admin is not authorized to read from: queue://wrong.queue' }
      its(:content) { should include 'User admin is not authorized to write to: queue://wrong.queue' }
    end
  end

  describe user('activemq') do
    it { should exist }
    it { should belong_to_group 'activemq' }
  end

  describe group('activemq') do
    it { should exist }
  end

end
