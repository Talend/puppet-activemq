class { '::java': }

packagecloud::repo { 'talend/other':
  type         => 'rpm',
  master_token => $packagecloud_master_token
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
class { '::activemq':
  pg_db       => 'ams',
  pg_username => 'ams',
  pg_password => 'ams'
} ->
exec { 'import ams db scheme':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -f /var/lib/activemq/lib/ams.sql && touch /tmp/ams.created',
  creates     => '/tmp/ams.created'
} ->
exec { 'import amqsec db scheme':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -f /var/lib/activemq/lib/amqsec.sql && touch /tmp/amqsec.created',
  creates     => '/tmp/amqsec.created'
} ->
exec { 'set password for the tadmin user':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -c /usr/bin/psql -U ams -h localhost -d ams -c "update amqsec_system_users set password = \'password\' where username = \'tadmin\'"',
} ->
file { '/tmp/stomp-producer.rb':
  content => "
    require 'onstomp'

    client = OnStomp.connect(\"stomp://#{ARGV[0]}:#{ARGV[1]}@0.0.0.0\")
    client.send(\"/queue/#{ARGV[2]}\", ARGV[3])
    client.disconnect
    "
} ->
file { '/tmp/stomp-consumer.rb':
  content => "
    require 'onstomp'

    client = OnStomp::Client.new(\"stomp://#{ARGV[0]}:#{ARGV[1]}@0.0.0.0\")
    client.connect
    client.subscribe(\"/queue/#{ARGV[2]}\", :ack => 'client') do |m|
      client.ack m
       puts \"Got a message: #{m.body}\"
    end

    sleep(1)
  "
} ->
package { 'onstomp':
  ensure   => installed,
  provider => 'gem'
}
