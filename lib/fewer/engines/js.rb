module Fewer
  module Engines
    class Js < Abstract
      def content_type
        'application/x-javascript'
      end

      def extension
        '.js'
      end
    end
  end
end
