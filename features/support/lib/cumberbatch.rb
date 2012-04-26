VMRE ||= /(?: on the last VM| on the VM(?: called|) "(?:[^"]+)"|)/

module Cumberbatch

    autoload :Platform, 'cumberbatch/platform'
    autoload :Guest,    'cumberbatch/guest'
    autoload :Registry, 'cumberbatch/registry'

    def vm_platform
        platform = :vagrant
        @vm_platform ||= Cumberbatch.platforms[ platform ].new()
    end
    
    def identified_vm( str )
        case str
            when /^( on the last VM|)$/
                return vm_platform.last_vm
            when /^ on the VM(?: called|) "([^"]+)"$/
                return @vm_platform.vm( $1 )
        end
    end

    def self.platforms
        @platforms ||= Registry.new
    end

    def self.guests
        @guests ||= Registry.new
    end

end

Cumberbatch.platforms.register(:vagrant) { Cumberbatch::Platform::Vagrant }

Cumberbatch.guests.register(:linux) { Cumberbatch::Guest::Linux }
