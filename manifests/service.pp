class activemq::service(

  $service_ensure = 'running',
  $service_enable = true

){

  include activemq::config

  service {'activemq':
    ensure   => $service_ensure,
    enable   => $service_enable,
    provider => $activemq::config::provider_type

  }

}