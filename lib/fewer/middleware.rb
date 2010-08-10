module Fewer
  class MiddleWare
    def initialize(app, options = {})
      @options = options
      @app = app
      @mount = @options[:mount]
    end

    def call(env)
      if env['PATH_INFO'] =~ /^#{@mount}/
        App.new(@options).call(env)
      else
        @app.call(env)
      end
    end
  end
end

