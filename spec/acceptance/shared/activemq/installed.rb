require 'spec_helper_acceptance'

shared_examples 'activemq::installed' do |parameters|

  it 'can be installed with no errors' do
    pp = <<-EOS
    class { '::java': }

    # init the talend repo in order to install the talend-activemq-auth package
    packagecloud::repo { 'talend/other':
      type         => 'rpm',
      master_token => '#{fact('PACKAGECLOUD_MASTER_TOKEN')}'
    } ->
    class { 'postgresql::globals':
      version             => '9.3',
      encoding            => 'UTF8',
      locale              => 'en_NG',
      manage_package_repo => true
    } ->
    class { 'postgresql::server':
      listen_addresses   => '*'
    } ->
    postgresql::server::db { 'ams':
      user     => 'ams',
      password => 'ams'
    } ->
    file { '/var/tmp/amqsec.sql':
      source => 'puppet:///modules/activemq/tmp/amqsec.sql'
    } ->
    file { '/var/tmp/ams.sql':
      source => 'puppet:///modules/activemq/tmp/ams.sql'
    } ->
    exec { 'import ams db scheme':
      environment => 'PGPASSWORD=ams',
      command     => '/usr/bin/psql -U ams -h localhost -d ams -f /var/tmp/ams.sql && touch /tmp/ams.created',
      creates     => '/tmp/ams.created'
    } ->
    exec { 'import amqsec db scheme':
      environment => 'PGPASSWORD=ams',
      command     => '/usr/bin/psql -U ams -h localhost -d ams -f /var/tmp/amqsec.sql && touch /tmp/amqsec.created',
      creates     => '/tmp/amqsec.created'
    } ->
    class { '::activemq':
      #{parameters.to_s}
    }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_failures => true)
  end

end
