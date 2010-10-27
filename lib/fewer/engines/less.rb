autoload :Less, 'less'

module Fewer
  module Engines
    class Less < Abstract
      self.content_type = 'text/css'
      self.extension = '.less'

      def read
        Dir.chdir root do
          ::Less::Engine.new(source).to_css
        end
      end
    end
  end
end
