module Cumberbatch

    class Registry

        def initialize
            @actions = {}
        end

        def register(key, value=nil, &block)
            block = lambda { value } if value
            @actions[key] = block
        end

        def get(key)

            if ! @actions.has_key?( key )
                return nil
            end

            return @actions[key].call
        end
        alias :[] :get

    end

end
