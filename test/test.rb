require 'minitest/autorun'
require 'google_cloud_messaging'

class Test < Minitest::Unit::TestCase

  def test_failToConnect
    gcm = GCM.new('cry -- unit testing GCM is kinda hard... what API to use?  What device ID?')
    gcm.send({ message: 'this will not go anywhere'}, [ 'key1', 'key2', 'key3'])
    assert_equal gcm.code, 401
  end

end