module Fewer
  module RailsHelpers
    def fewer_encode_sources(app, sources, friendly_ext = nil)
      ext = app.engine_klass.extension
      sources.map! { |source|
        ext && File.extname(source) == '' ? "#{source}#{ext}" : source
      }

      engines = if config.perform_caching
        [app.engine(sources)]
      else
        sources.map { |source|
          app.engine([source])
        }
      end

      engines.map { |engine|
        "#{engine.mtime.to_i.to_s(36)}/#{engine.encoded}#{friendly_ext}"
      }
    end

    def fewer_javascripts_tag(*sources)
      app = Fewer::App[:javascripts]
      javascript_include_tag *fewer_encode_sources(app, sources, '.js')
    end

    def fewer_stylesheets_tag(*sources)
      app = Fewer::App[:stylesheets]
      stylesheet_link_tag *fewer_encode_sources(app, sources, '.css')
    end
  end
end
