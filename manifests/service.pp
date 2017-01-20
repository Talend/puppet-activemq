class activemq::service (

  $service_ensure = $activemq::service_ensure,
  $service_enable = $activemq::service_enable,

){

  file { '/usr/lib/systemd/system/activemq.service':
    ensure  => present,
    content => template('activemq/activemq.service.erb'),
  } ->
  service { 'activemq':
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
