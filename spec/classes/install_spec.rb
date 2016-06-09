require 'spec_helper'
describe 'activemq' do

  let(:title) { 'activemq' }
  let(:node) { 'activemq.test.com' }

  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :memorysize_mb    => 1024,
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat',
                    :augeasversion    => '1.4.0',
                    :path             => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                    :kernel           => 'Linux',
                    :architecture     => 'x86_64',
                    :ipaddress        => '192.168.0.1'
    }}

    # Test if it compiles
    it { should compile }
    it { should have_resource_count(8)}

    # Test all default params are set
    it {
      should contain_class('activemq')
      should contain_class('activemq::params')
      should contain_class('activemq::install')
      should contain_class('activemq::config')
      should contain_class('activemq::service')
    }

  end
end
