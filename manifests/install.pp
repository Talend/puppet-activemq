class activemq::install (
  $version = $activemq::version,
){

  package {
    'activemq':
      ensure          => $version,
      install_options => ['--disablerepo=*', '--enablerepo=talend_other'];

    'talend-activemq-auth':
      ensure => installed
  }

}
