require 'test_helper'

class AppTest < Test::Unit::TestCase
  def test_engine_required
    assert_raises ArgumentError do
      Fewer::App.new(:name, :root => 'blah')
    end
  end

  def test_root_required
    assert_raises ArgumentError do
      Fewer::App.new(:name, :engine => 'blah')
    end
  end

  def test_named_apps_added_to_registry
    assert_nil Fewer::App[:name]

    app = Fewer::App.new(:name,
      :engine => stub(:new => stub),
      :root => 'blah'
    )

    assert_equal app, Fewer::App[:name]
  end
end
