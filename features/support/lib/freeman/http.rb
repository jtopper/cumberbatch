require 'uri'
require 'net/http'


module Freeman

    class Http

        def GET( uri_string )

            uri     = URI.parse( uri_string )
            http    = Net::HTTP.new( uri.host, uri.port )
            request = Net::HTTP::Get.new( uri.request_uri )

            t_start  = Time.now
            response = http.request( request )
            t_delta  = Time.now - t_start

            return {

                'code'    => response.code,
                'body'    => response.body,
                'message' => response.message,
                'headers' => response.header.to_hash

            }

        end

    end

end
