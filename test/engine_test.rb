require 'test_helper'

class EngineTest < Test::Unit::TestCase
  include TestHelper

  def test_sanitise_paths
    files = [
      'dir/ectory/file.js',
      'sub/dir/ectory/file.js',
      './../private.txt',
      '/etc/passwd',
      '/etc/../passwd'
    ]
    engine = engine_klass_no_checking.new('./happy-place', files)
    assert_equal [
      './happy-place/dir/ectory/file.js',
      './happy-place/sub/dir/ectory/file.js',
      './happy-place/./private.txt',
      './happy-place/etc/passwd',
      './happy-place/etc/passwd'
    ], engine.paths
  end

  def test_stringify_paths
    engine = engine_klass_no_checking.new('.', [:symbol, { :a => :b }])
    assert_equal ['./symbol', './ab'], engine.paths
  end

  def test_converts_names_to_an_array
    engine = engine_klass_no_checking.new(template_root, 'style')
    assert_equal ['style'], engine.names
  end

  def test_less_import_command
    engine = Fewer::Engines::Less.new(template_root, ['style'])
    assert_nothing_raised do
      engine.read
    end
  end

  private
    def engine_klass(&block)
      Class.new(Fewer::Engines::Abstract, &block)
    end

    def engine_klass_no_checking
      engine_klass do
        private
          def check_paths!; end
      end
    end
end
