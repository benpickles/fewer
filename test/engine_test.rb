require 'test_helper'

class EngineTest < Test::Unit::TestCase
  include TestHelper

  def teardown
    FakeFS::FileSystem.clear
  end

  def test_copes_with_pathnames
    root = Pathname.new(fs)
    path = Pathname.new(touch('a.css'))
    engine = Fewer::Engines::Abstract.new(root, [path])
  end

  def test_sanitise_paths
    paths = [
      'a.css',
      '/root/file.css',
      '/root/../passwd',
      '/root/./passwd',
      '/etc/passwd',
      '/etc/../passwd'
    ]
    engine = engine_klass_no_checking.new('/root', paths)
    assert_equal [
      '/root/a.css',
      '/root/file.css',
      '/root/passwd',
      '/root/passwd',
      '/root/etc/passwd',
      '/root/etc/passwd'
    ], engine.paths
  end

  def test_raises_error_for_missing_file
    assert_raises Fewer::MissingSourceFileError do
      Fewer::Engines::Abstract.new('root', ['does-not-exist'])
    end
  end

  def test_mtime_is_not_nil
    engine = Fewer::Engines::Abstract.new(fs, [])
    assert !engine.mtime.nil?
  end

  def test_can_deal_with_encoding_for_you
    paths = [touch('a.css'), touch('a.css')]
    engine = Fewer::Engines::Abstract.new(fs, paths)
    Fewer::Serializer.expects(:encode).with(fs, paths)
    engine.encoded
  end

  def test_less_import_command
    import = touch('import.less')
    style = fs('style.less')

    File.open(style, 'w') do |f|
      f.write '@import "import";'
    end

    engine = Fewer::Engines::Less.new(fs, [style])

    assert_nothing_raised do
      engine.read
    end
  end

  def test_read_source_files_once_when_generating_etag_and_content
    file = touch('a.css')
    engine = Fewer::Engines::Abstract.new(fs, [file])
    File.expects(:read).once.returns('')
    engine.etag
    engine.read
  end

  def test_generating_etag_should_not_process_content
    file = touch('a.less')
    engine = Fewer::Engines::Less.new(fs, [file])
    Less::Engine.expects(:new).never
    engine.etag
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
