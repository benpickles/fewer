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

class FakeFS::File
  def self.join(*parts)
    RealFile.join(parts)
  end
end

module TestHelper
  private
    def fs(path = '')
      root = File.expand_path('../fs', __FILE__)
      FileUtils.mkdir_p(root)
      File.join(root, path)
    end

    def template_root
      File.expand_path('../templates', __FILE__)
    end

    def touch(path)
      pathed = fs(path)
      FileUtils.touch(pathed)
      pathed
    end
end
