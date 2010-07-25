autoload :Closure, 'closure-compiler'

module Fewer
  module Engines
    class JsMin < Abstract
      def content_type
        'application/x-javascript'
      end

      def extension
        '.js'
      end

      def read
        ::Closure::Compiler.new.compress(super)
      end
    end
  end
end
