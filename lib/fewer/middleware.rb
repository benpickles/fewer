module Fewer
  class MiddleWare
    def initialize(app, name, options = {})
      @name = name
      @options = options
      @app = app
      @mount = @options[:mount]
    end

    def call(env)
      if env['PATH_INFO'] =~ /^#{@mount}/
        App.new(@name, @options).call(env)
      else
        @app.call(env)
      end
    end
  end
end

