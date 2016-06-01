class activemq::install {

  package {
    'activemq':
      ensure => $version;

    'talend-activemq-auth':
      ensure => installed
  }

  # cleanup leveldb log files once a day
  cron {
    'cleanup leveldb log':
      ensure  => $leveldb_clean_cron_ensure,
      command => "/bin/find /opt/activemq/data/leveldb -maxdepth 1 -regextype posix-egrep -regex '.+[0-9]{16}\\.log' -mtime +${leveldb_cleanup_days} -and -not -exec fuser -s {} ';' -and -delete",
      hour    => 0,
      minute  => 0
  }


}