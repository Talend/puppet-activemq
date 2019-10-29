class activemq::install (

  $version              = $activemq::version,
  $ams_security_version = pick($activemq::ams_security_version, 'latest'),
  $nginx_version        = pick($activemq::nginx_version, 'latest'),

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
    ensure => $ams_security_version,
  }

  yumrepo { 'nginx-stable':
    descr    => "nginx stable repo",
    baseurl  => "http://nginx.org/packages/centos/\$releasever/\$basearch/",
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => "https://nginx.org/keys/nginx_signing.key",
  } ->
  package { 'nginx':
    ensure => $nginx_version,
  }

}
