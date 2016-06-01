class activemq::params {

  #make up locally unique broker name
  $broker_name_uniq = regsubst($::ipaddress, '\.', '-','G')

  #in case of network of brokers we need unique name, but if replicated leveldb
  #is used we need global name
  $broker_name_real = pick($broker_name, $broker_name_uniq)
  $brokers_list = split($brokers, ',')

  #remove self from the list
  $brokers_list_real =  delete($brokers_list, $::hostname)

  $java_xmx = floor($::memorysize_mb * 0.70)
  $java_xms = floor($::memorysize_mb * 0.15)


}