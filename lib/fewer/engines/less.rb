autoload :Less, 'less'

module Fewer
  module Engines
    class Less < Abstract
      def content_type
        'text/css'
      end

      def extension
        '.less'
      end

      def read
        Dir.chdir root do
          ::Less::Engine.new(super).to_css
        end
      end
    end
  end
end
