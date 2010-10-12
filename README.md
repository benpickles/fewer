# Fewer

Fewer is a Rack endpoint to bundle and cache assets and help you make fewer HTTP requests. Fewer extracts and combines a list of assets encoded in the URL and serves the response with far-future HTTP caching headers.

## How to use in Rails 3

Using Fewer in your Rails app is easy, just initialize your Fewer apps and add them to your routes then include the helper methods in your `ApplicationHelper` with a one-liner.

    # Gemfile
    gem 'fewer'
    gem 'closure-compiler', :group => :production

    # config/initializers/fewer.rb
    require 'fewer'

    Fewer::App.new(:javascripts,
      :engine => Fewer::Engines::Js,
      :engine_options => { :min => Rails.env.production? },
      :root => Rails.root.join('app', 'javascripts')
    )
    Fewer::App.new(:stylesheets,
      :engine => Fewer::Engines::Css,
      :root => Rails.root.join('app', 'stylesheets')
    )

    # config/routes.rb
    match '/javascripts/:data.js', :to => Fewer::App[:javascripts]
    match '/stylesheets/:data.css', :to => Fewer::App[:stylesheets]

    # app/helpers/application_helper.rb
    module ApplicationHelper
      include Fewer::RailsHelpers
    end

    # app/views/layouts/application.html.erb
    <%= fewer_javascripts_tag 'long', 'list', 'of/nested', 'js/files' %>
    <%= fewer_stylesheets_tag 'some', 'css', 'files' %>

## How to use as a Rack app (config.ru example)

    app = Rack::Builder.new do
      map '/stylesheets' do
        run Fewer::App,
          :root => File.dirname(__FILE__)+'/less_css',
          :engine => Fewer::Engines::Less
      end

      map '/' do
        run MyApp
      end
    end

    run app

## Copyright

Copyright (c) 2010 Ben Pickles. See LICENSE for details.
