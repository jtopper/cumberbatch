When /^I apply a puppet manifest(#{VMRE}) containing:$/ do |vmre, manifest_content|

    vm = identified_vm( vmre )

    file = Tempfile.new('cucumber-puppet')
    begin
        file.write(manifest_content)
        file.fsync
        vm.upload(file.path,'/tmp/cucumber-puppet.pp')

        @puppet_command = "puppet apply --verbose " +
            "--modulepath=#{$puppet_modulepath} " +
            "--manifestdir=#{$puppet_manifestdir} " +
            "--detailed-exitcodes --color=false " + 
            "/tmp/cucumber-puppet.pp"

	puts "# #{@puppet_command}"

        exit_status = vm.sudo( @puppet_command ) do |type,data|
            data.chomp!
            if data != ""
                puts data
            end
        end

        Test::Unit::assert( exit_status == 0 || exit_status == 2, 'Exit code of puppet run not 0 or 2 - errors' )

    ensure
        file.close
        file.unlink
    end 

end

Then /^a second manifest application(#{VMRE}) should do nothing$/ do |vmre|

    vm = identified_vm( vmre )

    puts "# #{@puppet_command}"

    exit_status = vm.sudo( @puppet_command ) do |type,data|
        data.chomp!
        if data != ""
            puts data
        end
    end

    Test::Unit::assert_not_equal( exit_status, 2, 'Exit code of second puppet run indicated that changes were made' )

end

