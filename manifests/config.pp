class activemq::config {

  file {
    '/etc/sysconfig/activemq':
      content => template("${module_name}/etc/sysconfig/activemq.erb"),
      mode    => '0660',
      group   => 'activemq',
      require => Package['activemq'],
      notify  => Service['activemq'];

    '/etc/activemq/activemq.xml':
      content => template("${module_name}/etc/activemq/${activemq_template_name}"),
      mode    => '0660',
      group   => 'activemq',
      replace => $config_replace,
      require => Package['activemq'],
      notify  => Service['activemq'];
  }

  #  configure persistence
  if $persistence == 'replicated_leveldb' {
    $zookeepers_list = split($zookeeper_nodes, ',')
    $zk_address = inline_template('<%= @zookeepers_list.sort.join(":2181,") + ":2181" %>')

    #workaround - https://issues.apache.org/jira/browse/AMQ-5225
    file { '/opt/activemq/lib/pax-url-aether-1.5.2.jar':
      ensure  => absent,
      require => Package['activemq'],
      notify  => Service['activemq'];
    }
  }



}