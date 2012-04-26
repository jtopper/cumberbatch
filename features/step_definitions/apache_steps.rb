Then /^the Apache module "([^"]*)" should be loaded(#{VMRE})$/ do |target_module,vmre|

    target_module_count = 0

    # Conditionals cope with both redhat and ubuntu
    command = """
    if [ -x /usr/sbin/httpd ] ;
    then
        /usr/sbin/httpd -M 2>&1
    fi

    if [ -x /usr/sbin/apache2 ] ;
    then
        APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data /usr/sbin/apache2 -M 2>&1
    fi
    """

    vm = identified_vm( vmre )
    vm.sudo_as_lines( command )[:stdout].each { |line|

        if line =~ /^ (\S+) /

            loaded_module = Regexp.last_match(1)

            if loaded_module == target_module
                target_module_count += 1
            end

        end
    }

    assert( target_module_count > 0, "Module called #{target_module} not loaded" )

end
