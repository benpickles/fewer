require 'test_helper'

class SerializerTest < Test::Unit::TestCase
  include TestHelper

  def setup
    FileUtils.mkdir_p(fs('nested'))
    touch('a.css')
    touch('list.css')
    touch('nested/files.css')
    touch('of.css')
  end

  def teardown
    FakeFS::FileSystem.clear
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
      fs('nested/files.css'),
      fs('of.css')
    ])
    assert_equal '1023', encoded
  end

  def test_encode_some_files_in_a_different_order
    encoded = Fewer::Serializer.encode(fs, [
      fs('of.css'),
      fs('a.css'),
      fs('nested/files.css')
    ])
    assert_equal '2031', encoded
  end

  def test_encode_invalid_file
    encoded = Fewer::Serializer.encode(fs, ['doesnt-exist.css'])
    assert_equal '0000', encoded
  end

  def test_encode_35_files
    FakeFS::FileSystem.clear

    files = []
    35.times do |i|
      files << touch('%02d' % i + '.css')
    end

    encoded = Fewer::Serializer.encode(fs, files)
    assert_equal '123456789abcdefghijklmnopqrstuvwxyz', encoded
  end

  def test_encode_99_files
    FakeFS::FileSystem.clear

    files = []
    99.times do |i|
      files << touch('%02d' % i + '.css')
    end

    expected = '1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t' +
      ',u,v,w,x,y,z,10,11,12,13,14,15,16,17,18,19,1a,1b,1c,1d,1e,1f,1g,1h,' +
      '1i,1j,1k,1l,1m,1n,1o,1p,1q,1r,1s,1t,1u,1v,1w,1x,1y,1z,20,21,22,23,24' +
      ',25,26,27,28,29,2a,2b,2c,2d,2e,2f,2g,2h,2i,2j,2k,2l,2m,2n,2o,2p,2q,2r'
    assert_equal expected, Fewer::Serializer.encode(fs, files)
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
      fs('nested/files.css'),
      fs('of.css')
    ], decoded
  end

  def test_decode_some_files_in_a_different_order
    decoded = Fewer::Serializer.decode(fs, '2031')
    assert_equal [
      fs('of.css'),
      fs('a.css'),
      fs('nested/files.css')
    ], decoded
  end

  def test_decode_invalid_file
    decoded = Fewer::Serializer.decode(fs, '0000')
    assert_equal [], decoded
  end

  def test_decode_35_files
    FakeFS::FileSystem.clear

    files = []
    35.times do |i|
      files << touch('%02d' % i + '.css')
    end

    decoded = Fewer::Serializer.decode(fs, '123456789abcdefghijklmnopqrstuvwxyz')
    assert_equal files, decoded
  end

  def test_decode_99_files
    FakeFS::FileSystem.clear

    files = []
    99.times do |i|
      files << touch('%02d' % i + '.css')
    end

    encoded = '1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t' +
      ',u,v,w,x,y,z,10,11,12,13,14,15,16,17,18,19,1a,1b,1c,1d,1e,1f,1g,1h,' +
      '1i,1j,1k,1l,1m,1n,1o,1p,1q,1r,1s,1t,1u,1v,1w,1x,1y,1z,20,21,22,23,24' +
      ',25,26,27,28,29,2a,2b,2c,2d,2e,2f,2g,2h,2i,2j,2k,2l,2m,2n,2o,2p,2q,2r'
    assert_equal files, Fewer::Serializer.decode(fs, encoded)
  end
end
