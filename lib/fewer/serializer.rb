module Fewer
  module Serializer
    class << self
      def decode(root, encoded)
        files = ls(root)
        delimeter = files.length > 36 ? ',' : ''

        encoded.split(delimeter).map { |char|
          files[char.to_i(36)]
        }.compact
      end

      def encode(root, paths)
        files = ls(root)
        delimeter = files.length > 36 ? ',' : ''

        paths.map { |path|
          index = files.index(path)
          index ? index.to_s(36) : nil
        }.compact.join(delimeter)
      end

      private
        def ls(root)
          pattern = File.join(root, '**', '*.*')

          Dir.glob(pattern).delete_if { |path|
            File.directory?(path)
          }
        end
    end
  end
end
