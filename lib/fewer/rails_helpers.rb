module Fewer
  module RailsHelpers
    def fewer_encode_sources(app, sources, friendly_ext = nil)
      ext = app.engine_klass.extension
      sources.map! { |source|
        ext && File.extname(source) == '' ? "#{source}#{ext}" : source
      }

      if config.perform_caching
        engine = app.engine(sources)
        ["#{engine.mtime.to_i.to_s(36)}/#{engine.encoded}#{friendly_ext}"]
      else
        sources.map { |source|
          engine = app.engine([source])
          friendly_name = File.basename(source, '.*')
          "#{engine.mtime.to_i.to_s(36)}/#{engine.encoded}-#{friendly_name}#{friendly_ext}"
        }
      end
    end

    def fewer_javascripts_tag(*sources)
      options = sources.extract_options!
      app = Fewer::App[:javascripts]
      javascript_include_tag fewer_encode_sources(app, sources, '.js'), options
    end

    def fewer_stylesheets_tag(*sources)
      options = sources.extract_options!
      app = Fewer::App[:stylesheets]
      stylesheet_link_tag fewer_encode_sources(app, sources, '.css'), options
    end
  end
end
