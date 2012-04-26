Then /^a GET request to (.+)(#{VMRE}) should return an http status of (\d+)$/ do |url,vmre,status|

    vm = identified_vm( vmre )

    response = vm.freeman.call('http.GET',url)

    assert( response['code'].to_i == status.to_i, "Response code 200 expected from #{url}, received #{response['code']}" )

end
