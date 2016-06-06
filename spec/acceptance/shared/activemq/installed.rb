require 'spec_helper_acceptance'

shared_examples 'activemq::installed' do |parameters|

  it 'can be installed with no errors' do
    pp = <<-EOS
    class { '::java': }

    # init the talend repo in order to install the talend-activemq-auth package
    packagecloud::repo { 'talend/other':
      type         => 'rpm',
      master_token => '#{fact('PACKAGECLOUD_MASTER_TOKEN')}'
    } ->
    class { '::activemq':
      #{parameters.to_s}
    }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_failures => true)
  end

end
