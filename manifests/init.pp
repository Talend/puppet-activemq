class activemq (

  $version                         = 'latest',
  $jmx_enabled                     = false,
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
  $auth_refresh_interval           = '900000',
  $service_ensure                  = 'running',
  $service_enable                  = true,
  $persistence_pg_host             = undef,
  $persistence_pg_password         = undef,
  $ams_security_version            = 'latest',

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
