require 'xmlrpc/client'

module Freeman

    class AssertFail < StandardError ; end

    class Client

        def initialize( options = {} )
       
            host = options[:host] || 'localhost'
            port = options[:port] || 9000

            @xmlrpc = XMLRPC::Client.new( options[:host], '/', options[:port] )

        end

        def call ( *args )
            @xmlrpc.call( *args )
        end

        def assert( *args )

            result = call( *args )

            if( result['code'] != 0 ) 
                raise AssertFail, result['text']
            end

            nil

        end

    end

end
