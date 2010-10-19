require 'test_helper'

class RailsHelpersTest < Test::Unit::TestCase
  include TestHelper

  def setup
    @engine_klass = stub('klass', :extension => '.fewer')
    @engine = stub('engine',
      :encoded => 'qwerty',
      :mtime => Time.utc(2010, 8, 17, 21, 5, 24)
    )
    @app = stub('app', :engine_klass => @engine_klass, :engine => @engine)
    Fewer::App.stubs(:[] => @app)

    @helper = Class.new do
      include Fewer::RailsHelpers
    end.new
    @helper.stubs(:config => @config = stub(:perform_caching => true))
    @helper.stubs(:javascript_include_tag)
    @helper.stubs(:stylesheet_link_tag)
  end

  def test_extension_added_if_not_present
    @app.expects(:engine).with(['a.fewer', 'b.fewer']).returns(@engine)
    @helper.fewer_encode_sources @app, ['a', 'b']
  end

  def test_single_stylesheet_with_caching
    @helper.expects(:stylesheet_link_tag).with('l7bel0/qwerty.css')
    @helper.fewer_stylesheets_tag 'a.fewer', 'b.fewer'
  end

  def test_multiple_stylesheet_with_no_caching
    @config.stubs(:perform_caching => false)
    @helper.expects(:stylesheet_link_tag).with('l7bel0/qwerty.css', 'l7bel0/qwerty.css')
    @helper.fewer_stylesheets_tag 'a.fewer', 'b.fewer'
  end

  def test_single_javascript_with_caching
    @helper.expects(:javascript_include_tag).with('l7bel0/qwerty.js')
    @helper.fewer_javascripts_tag 'a.fewer', 'b.fewer'
  end

  def test_multiple_javascript_with_no_caching
    @config.stubs(:perform_caching => false)
    @helper.expects(:javascript_include_tag).with('l7bel0/qwerty.js', 'l7bel0/qwerty.js')
    @helper.fewer_javascripts_tag 'a.fewer', 'b.fewer'
  end
end
