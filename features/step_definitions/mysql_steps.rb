Then /^I should be able to connect to mysql(#{VMRE}) with username "([^"]*)" and password "([^"]*)"$/ do |vmre,username,password|
    vm = identified_vm( vmre )
    vm.freeman.assert('mysql.can_connect',username,password)
end

Then /^the mysql variable "([^"]*)"(#{VMRE}) should be "([^"]*)"$/ do |variable,vmre,value|
    vm = identified_vm( vmre )
    vars = vm.freeman.call('mysql.variables')
    assert( vars.has_key?(variable), "MySQL variable #{variable} not returned" )
    assert_equal( value, vars[variable], "MySQL variable #{variable} got wrong value" )
end
