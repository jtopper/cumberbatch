Given /^there is a running VM called "([^"]*)"$/ do |vm_name|

    vm_platform.vm( vm_name ).start    
    vm_platform.vm( vm_name ).snapshot

end

