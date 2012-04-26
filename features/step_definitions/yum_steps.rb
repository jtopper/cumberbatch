Then /^a yum repo called "([^"]*)"\s+should be configured and enabled(#{VMRE})$/ do |yum_repo,vmre|

    @yum_repo = yum_repo

    vm = identified_vm( vmre )
    vm.freeman.assert('yumrepo.repo_configured_and_enabled', yum_repo)

end


Then /^that yum repo should use GPG$/ do
    vm = vm_platform.last_vm
    vm.freeman.assert('yumrepo.repo_uses_gpg', @yum_repo)  
end

Then /^that yum repo should have an existing local file as its GPG key$/ do
    vm = vm_platform.last_vm
    vm.freeman.assert('yumrepo.repo_gpg_key_exists', @yum_repo)  
end

Then /^that yum repo should use a proxy of (.+)$/ do |proxy|
    vm = vm_platform.last_vm
    vm.freeman.assert('yumrepo.repo_uses_proxy', @yum_repo, proxy)
end
