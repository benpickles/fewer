require 'rubygems'
require 'bundler/setup'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fewer"
    gem.summary = 'Fewer is a Rack endpoint to bundle and cache assets and help you make fewer HTTP requests.'
    gem.description = 'Fewer is a Rack endpoint to bundle and cache assets and help you make fewer HTTP requests. Fewer extracts and combines a list of assets encoded in the URL and serves the response with far-future HTTP caching headers.'
    gem.email = 'spideryoung@gmail.com'
    gem.homepage = 'http://github.com/benpickles/fewer'
    gem.authors = ['Ben Pickles']
    gem.add_dependency('rack')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort 'RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov'
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fewer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
