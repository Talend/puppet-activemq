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
tomcat::instance { 'activemq-security-service':
  install_from_source => true,
  source_url          => 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz',
  catalina_base       => '/opt/apache-tomcat',
  java_home           => '/usr/java/default',
} ->
file { '/opt/tomcat':
  ensure => link,
  target => '/opt/apache-tomcat',
} ->
package { 'activemq-security-service':
  ensure => present,
} ->
file_line { 'amssec-password':
  ensure => present,
  path   => '/opt/tomcat/webapps/activemq-security-service/WEB-INF/classes/datasource.properties',
  line   => 'datasource.password=ams',
  match  => '^datasource\.password\=',
} ->
tomcat::config::server { 'localhost':
  port => '9988',
} ->
tomcat::config::server::connector { 'HTTP/1.1':
  port             => '9999',
  purge_connectors => true,
} ->
tomcat::config::server::host { 'localhost':
  app_base              => '/opt/apache-tomcat/webapps',
  catalina_base         => '/opt/apache-tomcat',
  host_ensure           => 'present',
  host_name             => 'localhost',
  parent_service        => 'Catalina',
  additional_attributes => {
    'unpackWARs' => true,
    'autoDeploy' => true
  },
} ->
tomcat::service { 'activemq-security-service':
  service_ensure => running,
  catalina_base  => '/opt/apache-tomcat',
  service_name   => 'activemq-security-service',
  use_init       => false,
  use_jsvc       => false,
} ->
class { '::activemq':
  pg_db       => 'ams',
  pg_username => 'ams',
  pg_password => 'ams',
  auth_url    => 'http://localhost:9999/activemq-security-service/authenticate',
} ->
exec { 'import ams db scheme':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -f /opt/activemq/lib/tipaas/ams.sql && touch /tmp/ams.created',
  creates     => '/tmp/ams.created'
} ->
exec { 'import amqsec db scheme':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -f /opt/activemq/lib/tipaas/amqsec.sql && touch /tmp/amqsec.created',
  creates     => '/tmp/amqsec.created'
} ->
exec { 'set password for the admin user':
  environment => 'PGPASSWORD=ams',
  command     => '/usr/bin/psql -U ams -h localhost -d ams -c "update amqsec_system_users set password = \'password\' where username = \'admin\'"',
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
