Then /^there should be a file called ([^ ]+)(#{VMRE})$/ do |filename,vmre|
    vm = identified_vm( vmre )
    vm.freeman.assert('file.exists',filename)
end
