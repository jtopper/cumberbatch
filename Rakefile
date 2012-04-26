require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

def all_features
    features = [ 'features/' ]
    features << Dir.glob('puppet/**/*.feature') 
    features
end

def report_options
    " --format html -o html/index.html --format pretty "
end

def create_report_dir
    unless File.directory? 'html/'
        Dir::mkdir( 'html/' )
    end
end


task :default do
    puts "No default task"
end

Cucumber::Rake::Task.new(:test) do |t|
  create_report_dir
  t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options
end

Cucumber::Rake::Task.new(:current) do |t|
  create_report_dir
  t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options + " --tags @current "
end

