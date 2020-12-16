class activemq (

  $version                         = 'latest',
  $jmx_enabled                     = false,
  $jmx_agent_opts                  = '',
  $dispatcher_response_queue       = 'ipaas.dispatcher.response.queue',
  $brokers                         = $::hostname,
  $min_brokers                     = 1,
  $clean_inactive_destinations     = true,
  $inactive_timeout_before_cleanup = 3000,
  $persistence                     = undef,
  $zk_password                     = undef,
  $zk_nodes                        = 'localhost',
  $zk_prefix                       = 'activemq',
  $pg_host                         = 'localhost',
  $pg_port                         = 5432,
  $pg_db                           = undef,
  $pg_username                     = undef,
  $pg_password                     = undef,
  $pg_init_connections             = 1,
  $pg_max_connections              = 16,
  $auth_url                        = 'http://localhost:8080/activemq-security-service/authenticate',
  $auth_refresh_interval           = '60000',
  $service_ensure                  = 'running',
  $service_enable                  = true,
  $persistence_pg_host             = undef,
  $persistence_pg_password         = undef,
  $ams_security_version            = 'latest',
  $jetty_admin_user                = 'admin',
  $jetty_admin_password            = 'admin',
  $jetty_server_min_threads        = '10',
  $jetty_server_max_threads        = '1000',
  $tcp_max_frame_size              = undef,
  $http_max_frame_size             = undef,
  $network_connector_uri           = undef,
  $network_connector_user          = undef,
  $network_connector_password      = undef,
) {

  class { '::activemq::install':
  } ->
  class { '::activemq::config':
  } ->
  class { '::activemq::service':
  }

  contain ::activemq::install
  contain ::activemq::config
  contain ::activemq::service
}
