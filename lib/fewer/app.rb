module Fewer
  class App
    class << self
      def [](name)
        apps[name]
      end

      def apps
        @apps ||= {}
      end
    end

    attr_reader :cache, :engine_klass, :engine_options, :name, :root

    def initialize(name, options = {})
      @engine_klass = options[:engine]
      @engine_options = options[:engine_options] || {}
      @mount = options[:mount]
      @root = options[:root]
      @cache = options[:cache] || 3600 * 24 * 365
      raise ArgumentError.new('You need to define an :engine class') unless @engine_klass
      raise ArgumentError.new('You need to define a :root path') unless @root
      self.class.apps[name] = self
    end

    def call(env)
      eng = engine(names_from_path(env['PATH_INFO']))
      headers = {
        'Content-Type' => eng.content_type,
        'Cache-Control' => "public, max-age=#{cache}",
        'Last-Modified' => eng.mtime.rfc2822
      }

      [200, headers, [eng.read]]
    rescue Fewer::MissingSourceFileError => e
      [404, { 'Content-Type' => 'text/plain' }, [e.message]]
    rescue StandardError => e
      [500, { 'Content-Type' => 'text/plain' }, ["#{e.class}: #{e.message}"]]
    end

    def engine(names)
      engine_klass.new(root, names, engine_options)
    end

    private
      def names_from_path(path)
        encoded = File.basename(path, '.*')
        Serializer.decode(root, encoded)
      end
  end
end
