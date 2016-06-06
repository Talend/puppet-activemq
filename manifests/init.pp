# Class: activemq
# ===========================
#
# Full description of class activemq here.
#
#
# Requires:
#
# Class['java']
#
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
#
#     $version,
#     $jmx_enabled                    = false,
#     $network_password               = undef,
#     $network_user                   = undef,
#     $dispatcher_response_queue      = 'ipaas.dispatcher.response.queue',
#     $brokers                        = undef,
#     $java_home                      = hiera('java::java_home'),
#     $min_brokers                    = 1,
#     $clean_inactive_destinations    = true,
#     $inactive_timout_before_cleanup = 3000,
#     $persistence                    = 'kahadb',
#     $zk_password                    = '',
#     $zookeeper_nodes                = undef,
#     $broker_name                    = undef,
#     $pg_host                        = undef,
#     $pg_port                        = 5432,
#     $pg_db                          = undef,
#     $pg_username                    = undef,
#     $pg_password                    = undef,
#     $pg_init_connections            = 1,
#     $pg_max_connections             = 16,
#     $auth_refresh_interval          = 900000,
#     $talend_activemq_auth_ensure    = 'installed',
#     $activemq_template_name         = 'activemq.xml.erb',
#     $zk_prefix                      = $::t_role,
#     $enable_leveldb_cleanup         = true,
#     $leveldb_cleanup_days           = 14
#
#
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'activemq':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Talend.
#
class activemq (

  $version                        = $activemq::params::version,
  $jmx_enabled                    = $activemq::params::jmx_enabled,
  $network_password               = $activemq::params::network_password,
  $network_user                   = $activemq::params::network_user,
  $dispatcher_response_queue      = $activemq::params::dispatcher_response_queue,
  $brokers                        = $activemq::params::brokers,
  $java_home                      = $activemq::params::java_home,
  $min_brokers                    = $activemq::params::min_brokers,
  $clean_inactive_destinations    = $activemq::params::clean_inactive_destinations,
  $inactive_timout_before_cleanup = $activemq::params::inactive_timout_before_cleanup,
  $persistence                    = $activemq::params::persistence,
  $zk_password                    = $activemq::params::zk_password,
  $zk_nodes                       = $activemq::params::zk_nodes,
  $pg_host                        = $activemq::params::pg_host,
  $pg_port                        = $activemq::params::pg_port,
  $pg_db                          = $activemq::params::pg_db,
  $pg_username                    = $activemq::params::pg_username,
  $pg_password                    = $activemq::params::pg_password,
  $pg_init_connections            = $activemq::params::pg_init_connections,
  $pg_max_connections             = $activemq::params::pg_max_connections,
  $auth_refresh_interval          = $activemq::params::auth_refresh_interval,
  $activemq_auth_ensure           = $activemq::params::activemq_auth_ensure,
  $enable_leveldb_cleanup         = $activemq::params::enable_leveldb_cleanup,
  $leveldb_cleanup_days           = $activemq::params::leveldb_cleanup_days,
  $service_ensure                 = $activemq::params::service_ensure,
  $service_enable                 = $activemq::params::service_enable,

) inherits activemq::params {
  # don't manage the activemq.xml until we have minimum number of brokers
  if size($activemq::params::brokers_list) >= $min_brokers {
    $config_replace = true
  } else {
    $config_replace = false
  }

  # this is used for communication betweek the extarnal and internal brokers
  if size($brokers_list) == 1 {
    $discovery_protocol = 'static'
  } else {
    $discovery_protocol = 'masterslave'
  }

  if $enable_leveldb_cleanup {
    $leveldb_clean_cron_ensure = 'present'
  } else {
    $leveldb_clean_cron_ensure = 'absent'
  }



  class { 'activemq::install': } ->
  class { 'activemq::config': } ~>
  class { 'activemq::service': } ->
  Class['activemq']

}
