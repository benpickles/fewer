module Fewer
  module Engines
    class Css < Abstract
      def content_type
        'text/css'
      end

      def extension
        '.css'
      end
    end
  end
end
