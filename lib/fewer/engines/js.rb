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
          begin
            ::Closure::Compiler.new.compress(super)
          rescue LoadError
            Fewer.logger.error "Javascript minification not available since the closure-compiler gem is not installed."
            super
          rescue StandardError => e
            # Unfortunately errors do not all descend from Closure::Error
            Fewer.logger.error "Exception raised in closure-compiler gem: #{e.class} (#{e.message}). Javascript returned without minification."
            super
          end
        else
          super
        end
      end
    end
  end
end
