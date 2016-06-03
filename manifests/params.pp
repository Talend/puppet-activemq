class activemq::params {

  $version                        = 'present'

  $java_home                      = '/usr/java/default'
  $jmx_enabled                    = false
  $network_password               = undef
  $network_user                   = undef
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

  $enable_leveldb_cleanup         = true
  $leveldb_cleanup_days           = 14

  $brokers                        = $::hostname
  $min_brokers                    = 1
  $broker_name                    = undef

  #make up locally unique broker name
  $broker_name_uniq = regsubst($::ipaddress, '\.', '-','G')

  #in case of network of brokers we need unique name, but if replicated leveldb
  #is used we need global name
  $broker_name_real = pick($broker_name, $broker_name_uniq)
  $brokers_list = split($brokers, ',')

  #remove self from the list
  $brokers_list_real =  delete($brokers_list, $::hostname)


}