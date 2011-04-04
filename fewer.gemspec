# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fewer/version"

Gem::Specification.new do |s|
  s.name        = "fewer"
  s.version     = Fewer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Pickles"]
  s.email       = ["spideryoung@gmail.com"]
  s.homepage    = 'https://github.com/benpickles/fewer'
  s.summary     = 'Fewer is a Rack endpoint to bundle and cache assets and help you make fewer HTTP requests.'
  s.description = 'Fewer is a Rack endpoint to bundle and cache assets and help you make fewer HTTP requests. Fewer extracts and combines a list of assets encoded in the URL and serves the response with far-future HTTP caching headers.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rack', '>= 0')

  s.add_development_dependency('activesupport')
  s.add_development_dependency('leftright') if RUBY_VERSION < '1.9'
  s.add_development_dependency('less')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('fakefs')
end
