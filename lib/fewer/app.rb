module Fewer
  class App
    attr_reader :engine_klass, :cache, :root

    def initialize(options = {})
      @engine_klass = options[:engine]
      @mount = options[:mount]
      @root = options[:root]
      @cache = options[:cache] || 3600 * 24 * 365
      raise 'You need to define an :engine class' unless @engine_klass
      raise 'You need to define a :root path' unless @root
    end

    def call(env)
      names = names_from_path(env['PATH_INFO'])
      engine = engine_klass.new(root, names)
      headers = {
        'Content-Type' => engine.content_type,
        'Cache-Control' => "public, max-age=#{cache}"
      }

      [200, headers, [engine.read]]
    rescue Fewer::MissingSourceFileError => e
      [404, { 'Content-Type' => 'text/plain' }, [e.message]]
    rescue => e
      [500, { 'Content-Type' => 'text/plain' }, ["#{e.class}: #{e.message}"]]
    end

    private
      def names_from_path(path)
        encoded = File.basename(path, '.*')
        Serializer.decode(encoded)
      end
  end
end
