module Freeman

    class File

        def exists(file)

        if( ! FileTest.exists?( file ) )
            return {
                'code' => 1,
                'text' => "File #{file} doesn't exist"
            }
        end

        return {
            'code' => 0,
            'text' => "OK"
        }

        end

    end

end
