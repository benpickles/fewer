# fewer

Rack middleware to bundle assets and help you make fewer HTTP requests.

## How to use in Rails (3)

    config.middleware.insert 0, Fewer::App, {
      :engine => Fewer::Engines::Css,
      :mount => '/stylesheets',
      :root => Rails.root.join('public', 'stylesheets')
    }

## Copyright

Copyright (c) 2010 Ben Pickles. See LICENSE for details.
