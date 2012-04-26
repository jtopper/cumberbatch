require 'rubygems'
require 'vagrant'
require 'open4'
require 'test/unit'

$:.push( File.join( File.dirname(__FILE__), 'lib' ) )
require 'cumberbatch'

include Test::Unit::Assertions
World( Cumberbatch )

def glob_to_vagrant_puppet_path( glob )

    puppet_path = []

    modules = Dir.glob ( glob )

    modules.each do |m|
        list = m.split( File::SEPARATOR )
        puppet_path.push( '/vagrant/' + list.join( '/' ) )
    end

    return puppet_path.join(':')

end

# Here be assumptions!
# Expecting to find a "puppet" directory in the path with the Vagrantfile and
#  Rakefile.
# Expecting to find directories under there which contain 'modules' and 'manifests'
#  directories.

$puppet_modulepath   = glob_to_vagrant_puppet_path( 'puppet/*/modules' )
$puppet_manifestdir  = glob_to_vagrant_puppet_path( 'puppet/*/manifests' )