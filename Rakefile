require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'vagrant'

$:.push( File.join( File.dirname(__FILE__), 'features', 'support', 'lib' ) )
require 'cumberbatch'

def create_report_dir
    unless File.directory? 'html/'
        Dir::mkdir( 'html/' )
    end
end

def run_cucumber( options = {} )

    config_file = options[:config_file] or raise 'Pass a :config_file'
    tags        = options[:tags]        || nil
    dry_run     = options[:dry_run]     || false

    config = Cumberbatch::Config.new( config_file )
    ENV['CUMBERBATCH_CONFIG'] = config_file
    ENV['PUPPET_PATH']        = config.puppet_path

    feature_files = Dir.glob("#{ config.puppet_path }/**/*.feature")

    create_report_dir

    cucumber_opts = [ '-r', 'features/' ]
    cucumber_opts.concat( feature_files )

    cucumber_opts.concat( [ '--format', 'html', '-o', 'html/index.html', '--format', 'pretty' ] )

    if ! tags.nil?
        cucumber_opts.concat( [ '--tags' ] )
        cucumber_opts.concat( tags )
    end

    cucumber_opts.concat( [ '--tags' ] )
    cucumber_opts.concat( config.cucumber_tags )

    if dry_run
        cucumber_opts.push('--dry-run')
    end

    require 'cucumber/cli/main'
    failure = Cucumber::Cli::Main.execute( cucumber_opts )
    raise "Cucumber failed" if failure

end

target_yml_configs = Dir.glob("**/*.yml")

target_yml_configs.each do |yml_file|

    rake_namespace = File.basename(yml_file).gsub(/\.yml$/,'')

    namespace rake_namespace.to_sym do

        desc "Run all Cucumber features with '#{rake_namespace}' config"
        task :default do
            run_cucumber( :config_file => yml_file )
        end

        desc "Run Cucumber @current features with '#{rake_namespace}' config"
        task :current do
            run_cucumber( :config_file => yml_file, :tags => [ '@current' ] )
        end

        desc "Clean up for '#{rake_namespace}' config"
        task :cleanup do
            ENV['CUMBERBATCH_CONFIG'] = yml_file
            ve = Vagrant::Environment.new(:ui_class => Vagrant::UI::Colored)
            ve.cli( 'destroy' )
        end

        desc "Run vagrant commands with namespace-appropriate config"
        task :vagrant, :command do |t, args|
            ENV['CUMBERBATCH_CONFIG'] = yml_file
            ve = Vagrant::Environment.new(:ui_class => Vagrant::UI::Colored)
            ve.cli( args.command.split(/\s+/) )
        end


    end

end
