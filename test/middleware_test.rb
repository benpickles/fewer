require 'test_helper'

class MiddlewareTest < Test::Unit::TestCase
  include TestHelper

  def setup
    @app = stub
    @engine = stub(
      :etag => '',
      :mtime => Time.utc(2010, 8, 17, 21, 5, 24),
      :read => 'content'
    )
    Fewer::Engines::Css.stubs(:new).returns(@engine)

    @app = Rack::Builder.new do
      map '/' do
        use Fewer::MiddleWare, :name,
              :root => '/some/root/path',
              :engine => Fewer::Engines::Css,
              :mount => '/css'
        run lambda { |env|
          [200, { 'Content-Type' => 'text/html' }, ['Hello World']]
        }
      end
    end

    @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
  end

  def test_middleware_intercepts_path
    @browser.get '/css/blah.css'
    assert_equal 'content', @browser.last_response.body
    assert_equal 'text/css', @browser.last_response.content_type
  end

  def test_middleware_delegates_to_app
    @browser.get "/blah/foobar.css"
    assert_equal 'Hello World', @browser.last_response.body
    assert_equal 'text/html', @browser.last_response.content_type
  end
end
