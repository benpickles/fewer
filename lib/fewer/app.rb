module Fewer
  class App
    attr_reader :app, :engine_klass, :cache, :mount, :root

    def initialize(app, options = {})
      @app = app
      @engine_klass = options[:engine]
      @mount = options[:mount]
      @root = options[:root]
      @cache = options[:cache] || 3600 * 24 * 365
    end

    def call(env)
      return app.call(env) unless env['PATH_INFO'] =~ /^#{mount}/

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
        encoded = File.basename(path.sub(/^#{mount}\/?/, ''), '.*')
        Serializer.decode(encoded)
      end
  end
end
