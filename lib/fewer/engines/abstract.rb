require 'digest/md5'

module Fewer
  module Engines
    class Abstract
      SANITISE_REGEXP = /\.?\.#{File::Separator}/

      attr_reader :options, :paths, :root

      def initialize(root, paths, options = {})
        @root = root.to_s
        @paths = paths
        @options = options
        sanitise_paths!
        check_paths!
      end

      def content_type
        'text/plain'
      end

      def encoded
        Serializer.encode(root, paths)
      end

      def extension
      end

      def mtime
        paths.map { |path|
          File.mtime(path)
        }.max || Time.now
      end

      def etag
        # MD5 for concatenation of all files
        Digest::MD5.hexdigest(paths.map { |path| File.read(path) }.join)
      end

      def read
        paths.map { |path|
          File.read(path)
        }.join("\n")
      end

      private
        def check_paths!
          missing = paths.reject { |path| File.exist?(path) }

          if missing.any?
            raise Fewer::MissingSourceFileError.new(
              "Missing source file#{'s' if missing.size > 1}:\n" +
              missing.join("\n"))
          end
        end

        def sanitise_paths!
          paths.map! { |path|
            path = path.to_s
            path.gsub!(SANITISE_REGEXP, '')
            path.replace(File.join(root, path)) if path[0, root.length] != root
            path
          }
        end
    end
  end
end
