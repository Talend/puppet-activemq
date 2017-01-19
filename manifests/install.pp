class activemq::install (

  $version              = $activemq::version,
  $activemq_auth_ensure = $activemq::activemq_auth_ensure,

) {

  package { 'activemq':
    ensure          => $version,
    install_options => ['--disablerepo=*', '--enablerepo=talend_other'],
  } ->
  package { 'talend-activemq-auth':
    ensure => $activemq_auth_ensure,
  }

}
