require 'yaml'

module Cumberbatch

    class Config

        def initialize ( conf_file )

            @yaml = YAML::load_file( conf_file )

        end

        def puppet_path
            @yaml[ 'puppet_path' ] || 'puppet/'
        end

        def vm_names
            [] if @yaml['vms'].nil?
            @yaml[ 'vms' ].each_key
        end

        def vm_details_by_name( name )
            @yaml['vms'][ name ]
        end

        def cucumber_tags
            [] if @yaml['tags'].nil?
            @yaml['tags']
        end


    end

end
