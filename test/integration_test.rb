require 'test_helper'

class IntegrationTest < Test::Unit::TestCase
  include TestHelper

  def setup
    @app = Fewer::App.new(:test, :engine => Fewer::Engines::Css, :root => fs)
    @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
  end

  def teardown
    FakeFS::FileSystem.clear
  end

  def test_initialises_a_new_engine_with_a_single_file
    path = touch('a.css')
    Fewer::Engines::Css.expects(:new).with(fs, [path], {}).returns(stub)
    @browser.get "/#{encode([path])}"
  end

  def test_initialises_a_new_engine_with_multiple_files
    paths = [touch('a.css'), touch('b.css')]
    Fewer::Engines::Css.expects(:new).with(fs, paths, {}).returns(stub)
    @browser.get "/#{encode(paths)}"
  end

  def test_responds_with_engine_content_type
    path = touch('a.css')
    @browser.get "/#{encode([path])}"
    assert_equal 'text/css', @browser.last_response.content_type
  end

  def test_responds_with_cache_control
    path = touch('a.css')
    @browser.get "/#{encode([path])}"
    assert_equal 'public, max-age=31536000', @browser.last_response.headers['Cache-Control']
  end

  def test_responds_with_last_modified
    File.stubs(:mtime => Time.utc(2010, 8, 17, 21, 5, 24))
    path = touch('a.css')
    @browser.get "/#{encode([path])}"
    assert_equal 'Tue, 17 Aug 2010 21:05:24 -0000', @browser.last_response.headers['Last-Modified']
  end

  def test_responds_with_bundled_content
    path = fs('a.css')
    File.open(path, 'w') do |f|
      f.write 'content'
    end

    @browser.get "/#{encode([path])}"
    assert_equal 'content', @browser.last_response.body
  end

  def test_responds_with_200
    path = touch('a.css')
    @browser.get "/#{encode([path])}"
    assert_equal 200, @browser.last_response.status
  end

  def test_responds_with_304_for_not_modified_requests
    file = touch('a.css')
    path = "/#{encode([path])}"
    @browser.get path
    etag = @browser.last_response.headers['ETag']
    @browser.header 'IF_NONE_MATCH', etag
    @browser.get path
    assert_equal 304, @browser.last_response.status
  end

  def test_responds_with_200_for_modified_requests
    file = touch('a.css')
    path = "/#{encode([path])}"
    @browser.get path
    File.open(fs('a.css'), 'w') { |f| f.write('blah') }
    etag = @browser.last_response.headers['ETag']
    @browser.header 'IF_NONE_MATCH', etag
    @browser.get path
    assert_equal 200, @browser.last_response.status
  end

  def test_responds_with_404_for_missing_source
    Fewer::Engines::Css.stubs(:new).raises(Fewer::MissingSourceFileError)
    @browser.get '/blah.css'
    assert_equal 404, @browser.last_response.status
  end

  def test_responds_with_500_for_other_errors
    Fewer::Engines::Css.stubs(:new).raises(RuntimeError)
    @browser.get '/blah.css'
    assert_equal 500, @browser.last_response.status
  end
end
