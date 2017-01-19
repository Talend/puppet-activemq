class activemq::service (

  $service_ensure = $activemq::service_ensure,
  $service_enable = $activemq::service_enable,

){

  service { 'activemq':
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
