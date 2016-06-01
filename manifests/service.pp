class activemq::service {

  #FIXME: move to parameters
  if $::t_subenv == 'build' {
    $service_ensure = 'stopped'
    $service_enable = false
  } else {
    $service_ensure = 'running'
    $service_enable = true
  }


  service {'activemq':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => [Package['activemq'], File['/etc/activemq/activemq.xml'], File['/etc/sysconfig/activemq']]
  }



}