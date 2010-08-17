require 'test_helper'

class AppTest < Test::Unit::TestCase
  include TestHelper

  def setup
    @app = stub
    @engine = stub(
      :check_request_extension => true,
      :content_type => 'text/css',
      :mtime => Time.utc(2010, 8, 17, 21, 5, 24),
      :read => 'content'
    )
    @engine_klass = stub(:new => @engine)
    @fewer_app = Fewer::App.new(:name,
      :engine => @engine_klass,
      :root => 'root'
    )
    @browser = Rack::Test::Session.new(Rack::MockSession.new(@fewer_app))
  end

  def test_can_retrieve_app_by_name
    assert_nil Fewer::App[:not_name]
    assert_equal @fewer_app, Fewer::App[:name]
  end

  def test_initialises_a_new_engine_with_a_single_file
    file = 'file'
    @engine_klass.expects(:new).with('root', file, {}).returns(@engine)
    @browser.get "/path/#{encode(file)}.css"
  end

  def test_initialises_a_new_engine_with_multiple_files
    files = ['file1', 'file2']
    @engine_klass.expects(:new).with('root', files, {}).returns(@engine)
    @browser.get "/path/#{encode(files)}.css"
  end

  def test_responds_with_engine_content_type
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 'text/css', @browser.last_response.content_type
  end

  def test_responds_with_cache_control
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 'public, max-age=31536000', @browser.last_response.headers['Cache-Control']
  end

  def test_responds_with_last_modified
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 'Tue, 17 Aug 2010 21:05:24 -0000', @browser.last_response.headers['Last-Modified']
  end

  def test_responds_with_bundled_content
    @engine.expects(:read).returns('content')
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 'content', @browser.last_response.body
  end

  def test_responds_with_200
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 200, @browser.last_response.status
  end

  def test_responds_with_404_for_missing_source
    @engine.stubs(:read).raises(Fewer::MissingSourceFileError)
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 404, @browser.last_response.status
  end

  def test_responds_with_500_for_other_errors
    @engine.stubs(:read).raises(RuntimeError)
    @browser.get "/path/#{encode('file')}.css"
    assert_equal 500, @browser.last_response.status
  end
end
