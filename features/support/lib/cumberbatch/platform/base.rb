module Cumberbatch

    module Platform

        class Base

            class VMNotFoundError < StandardError ; end

            attr_reader :last_vm

            def initialize
                @name_map    = {}
            end

            def vm(name)

                if @name_map.has_key?(name)
                    @last_vm = @name_map[name]
                    return @name_map[name]
                end

                vm = create_vm_object_by_name( name )

                @name_map[name] = vm
                @last_vm        = vm

                return vm

            end

            def clean_tainted
                @name_map.each { |name,vm|
                    vm.rollback
                    @name_map.delete(name)
                }
            end

        end

        class VMBase

            class VirtualMethodCalled < StandardError ; end

            def initialize( vagrant_vm )
                raise VirtualMethodCalled
            end

            def start
                raise VirtualMethodCalled
            end

            def stop
                raise VirtualMethodCalled
            end

            def snapshot
                raise VirtualMethodCalled
            end

            def rollback
                raise VirtualMethodCalled
            end

            def execute( command, &block )
                raise VirtualMethodCalled
            end

            def sudo( command, &block )
                raise VirtualMethodCalled
            end

            def sudo_as_lines ( command )

                output = {
                    :stdout => '',
                    :stderr => '',
                }

                sudo( command ) do |type,data|
                    output[type] += data
                end

                return {
                    :stdout => output[:stdout].split("\n"),
                    :stderr => output[:stderr].split("\n"),
                }

            end

            def upload( from, to )
                raise VirtualMethodCalled
            end

        end

    end

end
