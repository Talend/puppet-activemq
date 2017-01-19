class activemq (

  $version                        = '5.11.1-1',
  $jmx_enabled                    = false,
  $dispatcher_response_queue      = 'ipaas.dispatcher.response.queue',
  $brokers                        = $::hostname,
  $java_home                      = '/usr/java/default',
  $min_brokers                    = 1,
  $clean_inactive_destinations    = true,
  $inactive_timout_before_cleanup = 3000,
  $persistence                    = undef,
  $zk_password                    = undef,
  $zk_nodes                       = 'localhost',
  $zk_prefix                      = 'activemq',
  $pg_host                        = 'localhost',
  $pg_port                        = 5432,
  $pg_db                          = undef,
  $pg_username                    = undef,
  $pg_password                    = undef,
  $pg_init_connections            = 1,
  $pg_max_connections             = 16,
  $auth_refresh_interval          = 900000,
  $activemq_auth_ensure           = 'installed',
  $service_ensure                 = 'running',
  $service_enable                 = true,
  $persistence_pg_host            = undef,
  $persistence_pg_password        = undef,

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
