require 'uri'

module Freeman

    class Php

        def php_modules

            modules = []

            IO.popen( "php -m" ) { |php|
                php.each { |line|

                    next if line =~ /^\[/
                    next if line =~ /^$/

                    line.chomp!
                    modules.push( line )
                }
            }

            return modules

        end

        def pear_modules

            modules = []
            IO.popen( "pear list" ) { |php|
                php.each { |line|

                    next if line =~ /^\e/
                    next if line =~ /^=+$/

                    line.chomp!
                    attributes = line.split(/ +/)
                    modules.push ({
                        'package' => attributes[0],
                        'version' => attributes[1],
                        'state'   => attributes[2],
                    })
                }
            }

            return modules

        end

    end

end
