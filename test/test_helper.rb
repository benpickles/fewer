require 'fewer'

require 'fileutils'
require 'test/unit'

require 'rubygems'
require 'less'
require 'mocha'
require 'rack/test'

begin
  require 'leftright'
rescue LoadError
  puts "You're missing out on pretty colours! `gem install leftright`"
end

require 'fakefs'

module TestHelper
  private
    def fs(*args)
      @fs_root ||= File.expand_path('../fs', __FILE__)
      File.join(@fs_root, *args)
    end

    def template_root
      File.expand_path('../templates', __FILE__)
    end
end
