require_relative '../constants'
require_relative '../resource'

class KeyPair < Resource

  def initialize(key_pair)
    # => #<struct Aws::EC2::Types::KeyPairInfo
    #  key_fingerprint="98:2a:90:27:14:02:a4:5f:82:d6:db:a5:e2:9e:d2:97:a0:f2:24:29",
    #  key_name="hivemapper-dev-us-east-2-ohio">
    @key_pair = key_pair
  end

  def facts
    [
      [:typed_value, fingerprint = @key_pair.key_fingerprint, Cwacop::AWS.KeyFingerprint],
      [:type_value, name = @key_pair.key_name, Cwacop::AWS.KeyName]
    ]
  end

end