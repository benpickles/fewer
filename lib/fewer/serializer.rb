module Fewer
  module Serializer
    class << self
      def decode(root, encoded)
        paths = ls(root)
        selected = Array.new(paths.length)
        delimeter = encoded.index(',') ? ',' : //

        encoded.split(delimeter).each_with_index { |char, i|
          position = char.to_i(36) - 1
          selected[position] = paths[i] if position > -1
        }

        selected.compact
      end

      def encode(root, paths)
        delimeter = paths.length > 35 ? ',' : ''

        ls(root).map { |path|
          ((paths.index(path) || -1) + 1).to_s(36)
        }.join(delimeter)
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
