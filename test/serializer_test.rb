require 'test_helper'

class SerializerTest < Test::Unit::TestCase
  include TestHelper

  def setup
    FileUtils.mkdir_p fs('nested')
    FileUtils.touch fs('a.css')
    FileUtils.touch fs('list.css')
    FileUtils.touch fs('nested', 'files.css')
    FileUtils.touch fs('of.css')
  end

  def teardown
    FileUtils.rm_r fs
  end

  def test_encode_first_file
    encoded = Fewer::Serializer.encode(fs, [
      fs('a.css')
    ])
    assert_equal '1000', encoded
  end

  def test_encode_last_file
    encoded = Fewer::Serializer.encode(fs, [
      fs('of.css')
    ])
    assert_equal '0001', encoded
  end

  def test_encode_some_files
    encoded = Fewer::Serializer.encode(fs, [
      fs('a.css'),
      fs('nested', 'files.css'),
      fs('of.css')
    ])
    assert_equal '1023', encoded
  end

  def test_encode_some_files_in_a_different_order
    encoded = Fewer::Serializer.encode(fs, [
      fs('of.css'),
      fs('a.css'),
      fs('nested', 'files.css')
    ])
    assert_equal '2031', encoded
  end

  def test_encode_invalid_file
    encoded = Fewer::Serializer.encode(fs, ['doesnt-exist.css'])
    assert_equal '0000', encoded
  end

  def test_encode_35_files
    FileUtils.rm_r fs
    FileUtils.mkdir_p fs

    files = []
    35.times do |i|
      path = fs('%02d' % i + '.css')
      FileUtils.touch path
      files << path
    end

    encoded = Fewer::Serializer.encode(fs, files)
    assert_equal '123456789abcdefghijklmnopqrstuvwxyz', encoded
  end

  def test_decode_first_file
    decoded = Fewer::Serializer.decode(fs, '1000')
    assert_equal [
      fs('a.css')
    ], decoded
  end

  def test_decode_last_file
    decoded = Fewer::Serializer.decode(fs, '0001')
    assert_equal [
      fs('of.css')
    ], decoded
  end

  def test_decode_some_files
    decoded = Fewer::Serializer.decode(fs, '1023')
    assert_equal [
      fs('a.css'),
      fs('nested', 'files.css'),
      fs('of.css')
    ], decoded
  end

  def test_decode_some_files_in_a_different_order
    decoded = Fewer::Serializer.decode(fs, '2031')
    assert_equal [
      fs('of.css'),
      fs('a.css'),
      fs('nested', 'files.css')
    ], decoded
  end

  def test_decode_invalid_file
    decoded = Fewer::Serializer.decode(fs, '0000')
    assert_equal [], decoded
  end

  def test_decode_35_files
    FileUtils.rm_r fs
    FileUtils.mkdir_p fs

    files = []
    35.times do |i|
      path = fs('%02d' % i + '.css')
      FileUtils.touch path
      files << path
    end

    decoded = Fewer::Serializer.decode(fs, '123456789abcdefghijklmnopqrstuvwxyz')
    assert_equal files, decoded
  end
end
