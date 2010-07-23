require 'test_helper'

class AppTest < Test::Unit::TestCase
  def setup
    @app = stub
    @engine = stub(
      :check_request_extension => true,
      :content_type => 'text/css',
      :read => 'content'
    )
    @engine_klass = stub(:new => @engine)
    @fewer_app = Fewer::App.new(@app, {
      :engine => @engine_klass,
      :mount => '/path',
      :root => 'root'
    })
    @browser = Rack::Test::Session.new(Rack::MockSession.new(@fewer_app))
  end

  def test_initialises_a_new_engine_with_file_names
    @engine_klass.expects(:new).with('root', ['file1', 'file2']).returns(@engine)
    @browser.get '/path/file1,file2.css'
  end

  def test_responds_with_engine_content_type
    @browser.get '/path/file.css'
    assert_equal 'text/css', @browser.last_response.content_type
  end

  def test_responds_with_cache_control
    @browser.get '/path/file.css'
    assert_equal 'public, max-age=31536000', @browser.last_response.headers['Cache-Control']
  end

  def test_responds_with_bundled_content
    @engine.expects(:read).returns('content')
    @browser.get '/path/file.css'
    assert_equal 'content', @browser.last_response.body
  end

  def test_responds_with_200
    @browser.get '/path/file.css'
    assert_equal 200, @browser.last_response.status
  end

  def test_responds_with_404_for_missing_source
    @engine.stubs(:read).raises(Fewer::MissingSourceFileError)
    @browser.get '/path/file.css'
    assert_equal 404, @browser.last_response.status
  end

  def test_responds_with_500_for_other_errors
    @engine.stubs(:read).raises(RuntimeError)
    @browser.get '/path/file.css'
    assert_equal 500, @browser.last_response.status
  end
end
