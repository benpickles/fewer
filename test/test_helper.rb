require 'test/unit'

require 'rubygems'
require 'mocha'
require 'rack/test'

begin
  require 'redgreen'
rescue LoadError
end

require 'fewer'
