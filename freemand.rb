$:.push( File.expand_path( File.join( File.dirname(__FILE__), 'features', 'support', 'lib' ) ) )

require 'xmlrpc/server'
require 'optparse'

options = {}
optparse = OptionParser.new do |opts|

    options[:port] = 9000
    opts.on('-p', '--port PORT', 'Start on port PORT') do |port|
        options[:port] = port.to_i
    end

    options[:verbose] = false
    opts.on('-v', '--verbose', 'Verbose output') do
        options[:verbose] = true
    end

    options[:daemonize] = true
    opts.on('-f', '--foreground', 'Don\'t run as daemon') do
        options[:daemonize] = false
    end

    options[:log] = '/tmp/freeman.stderr'
    opts.on('-l', '--log LOG', 'Log to LOG') do |log|
        puts log
        options[:log] = log
    end

end

optparse.parse!

if options[:daemonize]

    # Would be nicer to use the daemonize gem here, but trying to
    #  reduce dependencies for in-guest process where possible

    raise 'First fork failed' if (pid = fork) == -1
    exit unless pid.nil?

    Process.setsid
    raise 'Second fork failed' if (pid = fork) == -1
    exit unless pid.nil?
    File.open('/tmp/freeman.pid', 'w') {|f| f.write( Process.pid ) }

    Dir.chdir '/'
    File.umask 0000

    STDIN.reopen '/dev/null'
    STDOUT.reopen '/dev/null', 'a'
    STDERR.reopen options[:log]

end

require 'freeman'
require 'freeman/test'
require 'freeman/yumrepo'
require 'freeman/http'
require 'freeman/php'
require 'freeman/file'
require 'freeman/mysql'

freeman = XMLRPC::Server.new( options[:port], '0.0.0.0', 4, $stderr )

# Enumerate classes under Freeman, auto handle them with xmlrpc
Freeman.constants.each do |c|

    const = Freeman.const_get(c)
    next unless const.class == Class

    freeman.add_handler( c.downcase, const.new )

end

freeman.serve
