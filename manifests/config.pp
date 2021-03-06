class activemq::config (

  $persistence                = $activemq::persistence,
  $zk_nodes                   = $activemq::zk_nodes,
  $zk_password                = $activemq::zk_password,
  $pg_host                    = $activemq::pg_host,
  $pg_port                    = $activemq::pg_port,
  $pg_db                      = $activemq::pg_db,
  $pg_username                = $activemq::pg_username,
  $pg_password                = $activemq::pg_password,
  $pg_init_connections        = $activemq::pg_init_connections,
  $pg_max_connections         = $activemq::pg_max_connections,
  $auth_url                   = $activemq::auth_url,
  $auth_refresh_interval      = $activemq::auth_refresh_interval,
  $brokers                    = $activemq::brokers,
  $jetty_admin_user           = $activemq::jetty_admin_user,
  $jetty_admin_password       = $activemq::jetty_admin_password,
  $jetty_server_min_threads   = $activemq::jetty_server_min_threads,
  $jetty_server_max_threads   = $activemq::jetty_server_max_threads,
  $tcp_max_frame_size         = $activemq::tcp_max_frame_size,
  $http_max_frame_size        = $activemq::http_max_frame_size,
  $network_connector_uri      = $activemq::network_connector_uri,
  $network_connector_user     = $activemq::network_connector_user,
  $network_connector_password = $activemq::network_connector_password,
) {

  $brokers_list      = split($brokers, ',')
  $brokers_list_real = delete($brokers_list, $::hostname)

  $broker_name_real = regsubst($::ipaddress, '\.', '-','G')

  $java_xmx         = floor($::memorysize_mb * 0.70)
  $java_xms         = floor($::memorysize_mb * 0.15)

  file { '/opt/activemq/conf/activemq.xml':
    content => template('activemq/activemq.xml.erb')
  }

  file { '/opt/activemq/conf/jetty-server.xml':
    content => template('activemq/jetty-server.xml.erb')
  }

  file { '/opt/activemq/conf/jetty-realm.properties':
    content => template('activemq/jetty-realm.properties.erb')
  }

  file { '/opt/activemq/bin/env':
    content => template('activemq/activemq.env.erb')
  }
}
