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


task :default do
    puts "No default task"
end

Cucumber::Rake::Task.new(:test) do |t|
  t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options
end

Cucumber::Rake::Task.new(:current) do |t|
  t.cucumber_opts = "-r features/ " + all_features.join(" ") + report_options + " --tags @current "
end

