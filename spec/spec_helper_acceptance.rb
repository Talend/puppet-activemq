require 'beaker-rspec'

# Load shared acceptance examples
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__), 'acceptance'))
Dir[base_spec_dir.join('shared/**/*.rb')].sort.each{ |f| require f }

# Install Puppet
unless ENV['RS_PROVISION'] == 'no'
  # This will install the latest available package on el and deb based
  # systems fail on windows and osx, and install via gem on other *nixes
  foss_opts = { :default_action => 'gem_install' }

  if default.is_pe?; then install_pe; else install_puppet( foss_opts ); end

  hosts.each do |host|
    on host, "mkdir -p #{host['distmoduledir']}"
  end
end

hosts.each do |host|
  on host, 'mkdir -p /etc/facter/facts.d'
  create_remote_file host, '/etc/facter/facts.d/packagecloud_facts.txt', "packagecloud_master_token=#{ENV['PACKAGECLOUD_MASTER_TOKEN']}", :protocol => 'rsync'

  # ActiveMQ stomp testing scripts
  create_remote_file host, '/tmp/stomp-producer.rb', "
  require 'onstomp'

  client = OnStomp.connect(\"stomp://\#{ARGV[0]}:\#{ARGV[1]}@0.0.0.0\")
  client.send(\"/queue/\#{ARGV[2]}\", ARGV[3])
  client.disconnect
  ", :protocol => 'rsync'

  create_remote_file host, '/tmp/stomp-consumer.rb', "
  require 'onstomp'

  client = OnStomp::Client.new(\"stomp://\#{ARGV[0]}:\#{ARGV[1]}@0.0.0.0\")
  client.connect
  client.subscribe(\"/queue/\#{ARGV[2]}\", :ack => 'client') do |m|
    client.ack m
     puts \"Got a message: \#{m.body}\"
  end

  sleep(1)
  ", :protocol => 'rsync'
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'activemq')
    hosts.each do |host|
      shell("/bin/touch #{default['puppetpath']}/hiera.yaml")
      shell('puppet module install puppetlabs-stdlib', { :acceptable_exit_codes => [0,1] })
      shell('puppet module install puppetlabs-java', { :acceptable_exit_codes => [0,1] })
      shell('puppet module install computology-packagecloud', { :acceptable_exit_codes => [0,1] })
      shell('puppet module install puppetlabs-postgresql', { :acceptable_exit_codes => [0,1] })
      shell('gem install onstomp', { :acceptable_exit_codes => [0] })
    end
  end
end
