require 'vagrant'

module Cumberbatch

    module Platform

        class Vagrant < Base

            def initialize
                @vagrant_env ||= ::Vagrant::Environment.new
                super()
            end

            protected

            def create_vm_object_by_name( name )

                vm = @vagrant_env.vms[ name.to_sym ]
                if vm.nil?
                    raise VMNotFoundError
                end

                return VagrantVM.new( @vagrant_env, vm )

            end

        end

        class VagrantVM < VMBase

            def initialize( vagrant_env, vagrant_vm )
                @vagrant_env = vagrant_env
                @vagrant_vm  = vagrant_vm
            end

            def execute( command, &block )
                @vagrant_vm.channel.execute(
                    command,
                    opts = { :error_check => false },
                    &block
                )
            end

            def sudo( command, &block )
                @vagrant_vm.channel.sudo(
                    command,
                    opts = { :error_check => false },
                    &block
                )
            end

            def upload( from, to )
                @vagrant_vm.channel.upload( from, to )
            end

            def start
                @vagrant_env.cli('up', @vagrant_vm.name)
            end
            
            def stop
                @vagrant_env.cli('halt', @vagrant_vm.name)
            end

            def snapshot
                @vagrant_env.cli('sandbox', 'on', @vagrant_vm.name)
            end

            def rollback
                @vagrant_env.cli('sandbox', 'rollback', @vagrant_vm.name)
            end

            def guest

                if ! @guest.nil?
                    return @guest
                end

                guest_klass = Cumberbatch.guests[ @vagrant_vm.config.vm.guest ]
                @guest = guest_klass.new( self )

            end

            def freeman

                if ! @freeman.nil?
                    return @freeman
                end

                guest.start_freeman
                
                # Automtaed systems administration is an exciting adventure in the 
                #  world of race conditions.
                sleep 3

                freeman_port_conf = @vagrant_vm.config.vm.forwarded_ports.find { 
                    |x| x[:name] == 'freeman' 
                }

                @freeman = Freeman::Client.new(
                    :host => 'localhost',
                    :port => freeman_port_conf[:hostport]
                )

            end

            def name
                @vagrant_vm.name
            end

        end

    end

end
