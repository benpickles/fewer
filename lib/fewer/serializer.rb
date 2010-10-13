module Fewer
  module Serializer
    class << self
      def decode(root, encoded)
        paths = ls(root)
        selected = Array.new(paths.length)

        encoded.split(//).each_with_index { |char, i|
          position = char.to_i(36) - 1
          selected[position] = paths[i] if position > -1
        }

        selected.compact
      end

      def encode(root, paths)
        ls(root).map { |path|
          ((paths.index(path) || -1) + 1).to_s(36)
        }.join
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
