require_relative '../resource'

class Subnet < Resource
  
  def initialize(subnet)
    # => #<struct Aws::EC2::Types::Subnet
    #  availability_zone="us-east-1b",
    #  availability_zone_id="use1-az1",
    #  available_ip_address_count=251,
    #  cidr_block="172.30.2.0/24",
    #  default_for_az=false,
    #  map_public_ip_on_launch=true,
    #  state="available",
    #  subnet_id="subnet-123",
    #  vpc_id="vpc-123",
    #  owner_id="123",
    #  assign_ipv_6_address_on_creation=false,
    #  ipv_6_cidr_block_association_set=[],
    #  tags=[],
    #  subnet_arn="arn:aws:ec2:us-east-1:123:subnet/subnet-123">
    @subnet = subnet
  end

  def subnet_id
    @subnet.subnet_id
  end

  def availability_zone
    @subnet.availability_zone
  end

  def vpc_id
    @subnet.vpc_id
  end

  def facts
    [
      [:typed_value, type_name, subnet_id],
      [:link, subnet_id, :az, availability_zone],
      [:link, subnet_id, :vpc, vpc_id]
    ]
  end

end