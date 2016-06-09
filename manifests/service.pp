class activemq::service (

  $service_ensure = 'running',
  $service_enable = true

){

  service {'activemq':
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
