autoload :Less, 'less'

module Fewer
  module Engines
    class Less < Abstract
      self.content_type = 'text/css'
      self.extension = '.less'

      def read
        bundled = super

        Dir.chdir root do
          ::Less::Engine.new(bundled).to_css
        end
      end
    end
  end
end
