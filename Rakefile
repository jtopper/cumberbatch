require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'vagrant'

$:.push( File.join( File.dirname(__FILE__), 'features', 'support', 'lib' ) )
require 'cumberbatch'

def report_options
    " --format html -o html/index.html --format pretty "
end

def create_report_dir
    unless File.directory? 'html/'
        Dir::mkdir( 'html/' )
    end
end

target_yml_configs = Dir.glob("**/*.yml")

target_yml_configs.each do |yml_file|

    rake_namespace = File.basename(yml_file).gsub(/\.yml$/,'')

    namespace rake_namespace.to_sym do

        ENV['CUMBERBATCH_CONFIG'] = yml_file
        config = Cumberbatch::Config.new( yml_file )

        ENV['PUPPET_PATH']        = config.puppet_path

        all_features = [ 'features/' ]
        all_features << Dir.glob("#{ config.puppet_path }/**/*.feature")

        Cucumber::Rake::Task.new( :test, "Run Cucumber features with '#{rake_namespace}' config" ) do |t|
            create_report_dir
            t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options
        end

        Cucumber::Rake::Task.new( :current, "Run Cucumber @current features with '#{rake_namespace}' config" ) do |t|
            create_report_dir
            t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options + " --tags @current "
        end

        desc "Run vagrant commands with namespace-appropriate config"
        task :vagrant, :command do |t, args|
            ve = Vagrant::Environment.new(:ui_class => Vagrant::UI::Colored)
            ve.cli( args.command.split(/\s+/) )
        end


    end

end
