require 'test_helper'

class EngineTest < Test::Unit::TestCase
  def test_sanitise_paths
    bad_files = ['./../private.txt', '/etc/passwd']
    engine = engine_klass_no_checking.new('./happy-place', bad_files)
    assert_equal ['./happy-place/private.txt', './happy-place/passwd'], engine.paths
  end

  def test_stringify_paths
    engine = engine_klass_no_checking.new('.', [:symbol, { :a => :b }])
    assert_equal ['./symbol', './ab'], engine.paths
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
