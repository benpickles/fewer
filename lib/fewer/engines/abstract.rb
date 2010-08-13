module Fewer
  module Engines
    class Abstract
      SANITISE_REGEXP = /^#{File::Separator}|\.\.#{File::Separator}/

      attr_reader :names, :root

      def initialize(root, names)
        @root = root
        @names = names.is_a?(Array) ? names : [names]
        sanitise_names!
        check_paths!
      end

      def content_type
        'text/plain'
      end

      def extension
      end

      def mtime
        paths.map { |path|
          File.mtime(path).to_i
        }.sort.last
      end

      def paths
        names.map { |name|
          File.join(root, "#{name}#{extension}")
        }
      end

      def read
        paths.map { |path|
          File.read(path)
        }.join("\n")
      end

      private
        def check_paths!
          if (missing = paths.reject { |path| File.exist?(path) }).any?
            files = missing.map { |path| path.to_s }.join("\n")
            raise Fewer::MissingSourceFileError.new("Missing source file#{'s' if missing.size > 1}:\n#{files}")
          end
        end

        def sanitise_names!
          names.map! { |name|
            name.to_s.gsub(SANITISE_REGEXP, '')
          }
        end
    end
  end
end
