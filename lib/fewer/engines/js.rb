autoload :Closure, 'closure-compiler'

module Fewer
  module Engines
    class Js < Abstract
      self.content_type = 'application/x-javascript'
      self.extension = '.js'

      def read
        if options[:min]
          ::Closure::Compiler.new.compress(super)
        else
          super
        end
      end
    end
  end
end
