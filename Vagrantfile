$:.push( File.join( File.dirname(__FILE__), 'features', 'support', 'lib' ) )
require 'cumberbatch'

if File.basename( $0 ) != 'rake' and !ENV.has_key?('CUMBERBATCH_CONFIG')
    $stderr.puts """
    This Vagrant configuration is a bit special, sorry.
    You need to either invoke Vagrant using one of the Rake tasks
    (try 'rake -T' for a list) or set CUMBERBATCH_CONFIG in
    the environment.
    """
    raise 'Sorry!'
end

Vagrant::Config.run do |config|

    cc = Cumberbatch::Config.new( ENV['CUMBERBATCH_CONFIG'] )

    cc.vm_names.each do |vm_name|

        cc_hash = cc.vm_details_by_name( vm_name )

        config.vm.define vm_name.to_sym do |server_config|

            server_config.vm.box     = cc_hash['box']
            server_config.vm.box_url = cc_hash['box_url']

            server_config.vm.customize [ "modifyvm", :id, "--memory", cc_hash['box_ram'].to_s ]

            server_config.vm.forward_port 9000, cc_hash['freeman_port'], :name => 'freeman'

            if cc_hash.has_key?('provision')
                server_config.vm.provision :shell, :inline => cc_hash['provision']
            end

        end

    end

end
