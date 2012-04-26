Vagrant::Config.run do |config|

    config.vm.define :server do |server_config|

        server_config.vm.box     = 'lucid32'
        server_config.vm.box_url = 'http://files.vagrantup.com/lucid32.box'

        server_config.vm.customize [ "modifyvm", :id, "--memory", "1024" ]

        server_config.vm.forward_port 9000, 9000, :name => 'freeman'
        server_config.vm.provision :shell, :inline => 'adduser --system --group puppet'

    end

end
