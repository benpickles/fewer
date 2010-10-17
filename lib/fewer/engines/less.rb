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
        bundled = super

        Dir.chdir root do
          ::Less::Engine.new(bundled).to_css
        end
      end
    end
  end
end
