class activemq::params {

  $version                        = '5.11.1-1'

  $java_home                      = '/usr/java/default'
  $jmx_enabled                    = false
  $dispatcher_response_queue      = 'ipaas.dispatcher.response.queue'

  $service_ensure                 = 'running'
  $service_enable                 = true

  $pg_host                        = 'localhost'
  $pg_port                        = 5432
  $pg_db                          = undef
  $pg_username                    = undef
  $pg_password                    = undef
  $pg_init_connections            = 1
  $pg_max_connections             = 16

  $auth_refresh_interval          = 900000
  $activemq_auth_ensure           = 'installed'
  $clean_inactive_destinations    = true
  $inactive_timout_before_cleanup = 3000
  $persistence                    = undef
  $zk_password                    = undef
  $zk_nodes                       = 'localhost'
  $zk_prefix                      = 'activemq'

  $brokers                        = $::hostname
  $min_brokers                    = 1

  $brokers_list = split($brokers, ',')

  #remove self from the list
  $brokers_list_real =  delete($brokers_list, $::hostname)

}
