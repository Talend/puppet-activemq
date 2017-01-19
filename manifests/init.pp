class activemq (

  $version                        = $activemq::params::version,
  $jmx_enabled                    = $activemq::params::jmx_enabled,
  $dispatcher_response_queue      = $activemq::params::dispatcher_response_queue,
  $brokers                        = $activemq::params::brokers,
  $java_home                      = $activemq::params::java_home,
  $min_brokers                    = $activemq::params::min_brokers,
  $clean_inactive_destinations    = $activemq::params::clean_inactive_destinations,
  $inactive_timout_before_cleanup = $activemq::params::inactive_timout_before_cleanup,
  $persistence                    = $activemq::params::persistence,
  $zk_password                    = $activemq::params::zk_password,
  $zk_nodes                       = $activemq::params::zk_nodes,
  $zk_prefix                      = $activemq::params::zk_nodes,
  $pg_host                        = $activemq::params::pg_host,
  $pg_port                        = $activemq::params::pg_port,
  $pg_db                          = $activemq::params::pg_db,
  $pg_username                    = $activemq::params::pg_username,
  $pg_password                    = $activemq::params::pg_password,
  $pg_init_connections            = $activemq::params::pg_init_connections,
  $pg_max_connections             = $activemq::params::pg_max_connections,
  $auth_refresh_interval          = $activemq::params::auth_refresh_interval,
  $activemq_auth_ensure           = $activemq::params::activemq_auth_ensure,
  $service_ensure                 = $activemq::params::service_ensure,
  $service_enable                 = $activemq::params::service_enable,
  $persistence_pg_host            = undef,
  $persistence_pg_password        = undef,
  $pg_init_connections            = $activemq::params::pg_init_connections,
  $pg_max_connections             = $activemq::params::pg_max_connections

) inherits activemq::params {

  # don't manage the activemq.xml until we have minimum number of brokers
  if size($activemq::params::brokers_list) >= $min_brokers {
    $config_replace = true
  } else {
    $config_replace = false
  }

  # this is used for communication between the external and internal brokers
  if size($activemq::params::brokers_list) == 1 {
    $discovery_protocol = 'static'
  } else {
    $discovery_protocol = 'masterslave'
  }

  class { 'activemq::install': }
  class { 'activemq::config': }
  class { 'activemq::service': }

  anchor { 'activemq::begin': }
  anchor { 'activemq::end': }

  Anchor['activemq::begin'] ->
    Class['activemq::install'] ->
    Class['activemq::config'] ~>
    Class['activemq::service'] ->
  Anchor['activemq::end']

}
