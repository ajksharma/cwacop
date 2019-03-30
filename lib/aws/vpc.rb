require_relative '../constants'
require_relative '../resource'

class VPC < Resource

  def initialize(vpc)
    # => #<struct Aws::EC2::Types::DescribeVpcsResult
    #  vpcs=
    #   [#<struct Aws::EC2::Types::Vpc
    #     cidr_block="172.30.0.0/16",
    #     dhcp_options_id="dopt-123",
    #     state="available",
    #     vpc_id="vpc-123",
    #     owner_id="123",
    #     instance_tenancy="default",
    #     ipv_6_cidr_block_association_set=[],
    #     cidr_block_association_set=
    #      [#<struct Aws::EC2::Types::VpcCidrBlockAssociation
    #        association_id="vpc-cidr-assoc-123",
    #        cidr_block="172.30.0.0/16",
    #        cidr_block_state=#<struct Aws::EC2::Types::VpcCidrBlockState state="associated", status_message=nil>>],
    #     is_default=false,
    #     tags=[]>],
    #  next_token=nil>
    @vpc = vpc
  end

  def vpc_id
    @vpc.vpc_id
  end

  def cidr_block
    @vpc.cidr_block
  end

  def facts
    [
      [:typed_value, vpc_id, Cwacop::AWS::VPC],
      [:typed_value, cidr_block, Cwacop::AWS::CidrBlock],
      [:link, vpc_id, cidr_block]
    ]
  end

end