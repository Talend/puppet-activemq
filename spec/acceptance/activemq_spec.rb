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

  context 'when accessed with proper credentials' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb tadmin password ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/ruby /tmp/stomp-consumer.rb tadmin password ipaas.testing.notification.manager.queue') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should include 'test_data' }
    end
  end

  context 'when accessed with wrong username' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb nonexistentuser password ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 1 }
    end

    describe file('/opt/activemq/data/activemq.log') do
      its(:content) { should include 'User \'nonexistentuser\' not found or password is wrong.' }
    end
  end

  context 'when accessed with wrong password' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb tadmin wrongpassword ipaas.testing.notification.manager.queue test_data') do
      its(:exit_status) { should eq 1 }
    end

    describe file('/opt/activemq/data/activemq.log') do
      its(:content) { should include 'User \'tadmin\' not found or password is wrong.' }
    end
  end

  context 'when trying to work with a wrong queue' do
    describe command('/usr/bin/ruby /tmp/stomp-producer.rb tadmin password wrong.queue test_data') do
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/ruby /tmp/stomp-consumer.rb tadmin password wrong.queue') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should_not include 'test_data' }
    end

    describe file('/opt/activemq/data/activemq.log') do
      its(:content) { should include 'User tadmin is not authorized to read from: queue://wrong.queue' }
      its(:content) { should include 'User tadmin is not authorized to write to: queue://wrong.queue' }
    end
  end

end
