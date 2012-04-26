require 'pp'

Then /^the PHP module "([^"]*)" should be available(#{VMRE})$/ do |php_module,vmre|

    vm = identified_vm( vmre )
    modules = vm.freeman.call('php.php_modules')
    assert( ! modules.index( php_module ).nil?, "PHP module #{php_module} not present" )

end

Then /^the PEAR module "([^"]*)" should be available(#{VMRE})$/ do |pear_module,vmre|

    vm = identified_vm( vmre )
    modules = vm.freeman.call('php.pear_modules')

end

Then /^the following PHP modules should be available(#{VMRE}):$/ do |vmre,table|

    vm = identified_vm( vmre )

    failed_rows = []
    table.hashes.each do |row|
        failed_rows << row unless module_available?(row['Type'], row['Module'], vm)
    end
    
    raise("The following modules were not available: #{failed_rows.inspect}") if failed_rows.any?

end

module ModulesHelper

    @pear_modules = nil
    @php_modules  = nil

    def module_available?(type, name, vm)

        if type == 'PEAR'

            modules = @pear_modules || vm.freeman.call('php.pear_modules')
            return ! modules.map { |x| x['package'] }.index(name).nil?

        elsif type == 'PHP'

            modules = @php_modules || vm.freeman.call('php.php_modules')
            return ! modules.index(name).nil?

        end

    end
end

World(ModulesHelper)
