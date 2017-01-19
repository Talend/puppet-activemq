class activemq::config (

  $activemq_template_name         = $activemq::activemq_template_name,
  $persistence                    = $activemq::persistence,
  $zk_nodes                       = $activemq::zk_nodes,
  $zk_password                    = $activemq::zk_password,
  $pg_host                        = $activemq::pg_host,
  $pg_port                        = $activemq::pg_port,
  $pg_db                          = $activemq::pg_db,
  $pg_username                    = $activemq::pg_username,
  $pg_password                    = $activemq::pg_password,
  $pg_init_connections            = $activemq::pg_init_connections,
  $pg_max_connections             = $activemq::pg_max_connections,
  $auth_refresh_interval          = $activemq::auth_refresh_interval,
  $talend_activemq_auth_ensure    = $activemq::activemq_auth_ensure,
  $java_home                      = $activemq::java_home

){

  $broker_name_real = regsubst($::ipaddress, '\.', '-','G')
  $java_xmx         = floor($::memorysize_mb * 0.70)
  $java_xms         = floor($::memorysize_mb * 0.15)

  file {
    '/etc/sysconfig/activemq':
      content => template('activemq/activemq.sysconf.erb'),
      mode    => '0660',
      group   => 'activemq';
    '/etc/activemq/activemq.xml':
      content => template('activemq/activemq.xml.erb'),
      mode    => '0660',
      group   => 'activemq';
  }

  #  configure persistence
  if $persistence == 'replicated_leveldb' {

    $zookeepers_list = split($zk_nodes, ',')
    $zk_address = inline_template('<%= @zookeepers_list.sort.join(":2181,") + ":2181" %>')

    #workaround - https://issues.apache.org/jira/browse/AMQ-5225
    file { '/opt/activemq/lib/pax-url-aether-1.5.2.jar':
      ensure  => 'absent',
    }
  }
}
