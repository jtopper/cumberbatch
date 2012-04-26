require 'to_regexp'

Then /^there should be (\S+) process(es|) matching (.+) running(#{VMRE})$/ do |number,none,process_re,vmre|

    list = []

    vm = identified_vm( vmre )
    processlist = vm.guest.processlist

    processlist.each do |p|

        if p[:comm] =~ process_re.to_regexp
            list.push( p )
        end

    end

    if number == 'some'
        assert( list.length > 0, "No processes matching #{process_re} running" )
    elsif number == 'a'
        assert( list.length == 1, "Should be 1 process matching #{process_re} (was #{list.length})")
    else
        assert_equal( number.to_i, list.length, "Wrong number of processes matching #{process_re} running" )
    end
end

Then /^a process matching (.+) should be listening on (TCP|UDP) port (\d+)(#{VMRE})$/ do |process_re,proto,port,vmre|

    match_count = 0

    vm = identified_vm( vmre )
    vm.sudo_as_lines( 'netstat -nlp' )[:stdout].each do |line|

        next unless line.start_with?( proto.downcase )
        fields = line.split(/\s+/)

        if proto == 'TCP'
            next unless fields[5] == 'LISTEN'
        end

        #"tcp", "0", "0", "0.0.0.0:111", "0.0.0.0:*", "LISTEN", "1070/rpcbind"]

        local_port   = fields[3].split(/:/).last
        process_name = fields[ proto == 'TCP' ? 6 : 5 ].split(/\//).last

        if local_port == port && process_re.match( process_name )
            match_count += 1
        end

    end

    assert( match_count > 0, "No process matching #{process_re} bound to port #{port}" )

end
