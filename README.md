# fewer

Rack middleware to bundle assets and help you make fewer HTTP requests.

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

## How to use in Rails 3 router

    match '/stylesheets/:data.css', :to => Fewer::App.new(
      :engine => Fewer::Engines::Less,
      :root => Rails.root.join('app', 'stylesheets')
    )

## How to use in Rails as middleware

    config.middleware.use Fewer::MiddleWare, {
      :engine => Fewer::Engines::Less,
      :mount => '/stylesheets',
      :root => Rails.root.join('app', 'stylesheets')
    }

## Copyright

Copyright (c) 2010 Ben Pickles. See LICENSE for details.
