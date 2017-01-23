class activemq::config (

  $persistence           = $activemq::persistence,
  $zk_nodes              = $activemq::zk_nodes,
  $zk_password           = $activemq::zk_password,
  $pg_host               = $activemq::pg_host,
  $pg_port               = $activemq::pg_port,
  $pg_db                 = $activemq::pg_db,
  $pg_username           = $activemq::pg_username,
  $pg_password           = $activemq::pg_password,
  $pg_init_connections   = $activemq::pg_init_connections,
  $pg_max_connections    = $activemq::pg_max_connections,
  $auth_url              = $activemq::auth_url,
  $auth_refresh_interval = $activemq::auth_refresh_interval,
  $brokers               = $activemq::brokers,

) {

  $brokers_list      = split($brokers, ',')
  $brokers_list_real = delete($brokers_list, $::hostname)

  $broker_name_real = regsubst($::ipaddress, '\.', '-','G')

  $java_xmx         = floor($::memorysize_mb * 0.70)
  $java_xms         = floor($::memorysize_mb * 0.15)

  file { '/opt/activemq/conf/activemq.xml':
    content => template('activemq/activemq.xml.erb')
  }

  file { '/opt/activemq/bin/env':
    content => template('activemq/activemq.env.erb')
  }

}
