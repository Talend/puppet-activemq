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

class { 'limits':
  limits_file => '/tmp/limits.conf'
}
limits::fragment { 'nginx-soft':
  domain => 'nging',
  type   => 'soft',
  item   => 'nofile',
  value  => '102400',
}
limits::fragment { 'nginx-soft':
  domain => 'nging',
  type   => 'hard',
  item   => 'nofile',
  value  => '102400',
}
