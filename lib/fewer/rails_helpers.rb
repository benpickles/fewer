module Fewer
  module RailsHelpers
    def fewer_javascripts_tag(*names)
      engine = Fewer::App[:javascripts].engine(names)
      javascript_include_tag "#{engine.encoded}.js?#{engine.mtime}"
    end

    def fewer_stylesheets_tag(*names)
      engine = Fewer::App[:stylesheets].engine(names)
      stylesheet_link_tag "#{engine.encoded}.css?#{engine.mtime}"
    end
  end
end
