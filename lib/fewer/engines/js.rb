autoload :Closure, 'closure-compiler'

module Fewer
  module Engines
    class Js < Abstract
      def content_type
        'application/x-javascript'
      end

      def extension
        '.js'
      end

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
