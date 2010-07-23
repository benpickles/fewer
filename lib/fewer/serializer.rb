require 'base64'

module Fewer
  module Serializer
    class BadString < RuntimeError; end

    class << self
      def b64_decode(string)
        padding_length = string.length % 4
        Base64.decode64(string + '=' * padding_length)
      end

      def b64_encode(string)
        Base64.encode64(string).tr("\n=",'')
      end

      def marshal_decode(string)
        Marshal.load(b64_decode(string))
      rescue TypeError, ArgumentError => e
        raise BadString, "couldn't decode #{string} - got #{e}"
      end
      alias_method :decode, :marshal_decode

      def marshal_encode(object)
        b64_encode(Marshal.dump(object))
      end
      alias_method :encode, :marshal_encode
    end
  end
end
