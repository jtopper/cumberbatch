require 'pp'

After('~@norollback') do |scenario|
    puts "Rolling back VM states"
    vm_platform.clean_tainted
end

After('@norollback') do |scenario|
    puts "Saw @norollback tag - not rolling back"
end
