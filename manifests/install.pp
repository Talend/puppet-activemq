class activemq::install (

  $version = $activemq::version,

) {

  group { 'activemq':
    ensure => present,
    gid    => '92',
    system => true,
  } ->
  user { 'activemq':
    ensure => present,
    gid    => '92',
    uid    => '92',
    home   => '/opt/activemq',
    shell  => '/bin/bash',
  } ->
  package { 'activemq':
    ensure => $version,
  } ->
  package { 'activemq-security-plugin':
    ensure => installed,
  }

}
