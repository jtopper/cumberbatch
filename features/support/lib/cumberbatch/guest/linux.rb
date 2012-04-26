module Cumberbatch

    module Guest

        class Linux < Base

            def initialize( vm )
                @vm = vm
            end

            def processlist

                output = ''

                @vm.sudo( 'ps --no-headers -eo pid,user,comm,args' ) do |type,data|
                    if type == :stdout
                        data.chomp!
                        output += data
                    end
                end

                processes = []

                output.split("\n").each do |line|

                    if line =~ /^ *(\d+) +([^ ]+) +([^ ]+) +(.*?)$/
                        processes.push( { 
                            :pid  => $1,
                            :user => $2,
                            :comm => $3,
                            :args => $4
                        } )
                    end
                end

                return processes

            end

            def netstat
            end

            def file_exists
            end

            def start_freeman

                stderr = ''

                cmd = "ruby /vagrant/freemand.rb"

                return_value = @vm.sudo( cmd ) do |type,data|
                    if type == :stderr
                        stderr += data
                    end
                end

                if return_value != 0
                    raise "Freeman didn't start on the guest"
                end

            end

        end

    end

end
