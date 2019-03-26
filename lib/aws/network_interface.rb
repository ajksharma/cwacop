require_relative '../constants'
require_relative '../resource'

class NetworkInterface < Resource

  def initialize(network_interface)
    # => #<struct Aws::EC2::Types::NetworkInterface
    #  association=nil,
    #  attachment=
    #   #<struct Aws::EC2::Types::NetworkInterfaceAttachment
    #    attach_time=2018-04-05 21:32:50 UTC,
    #    attachment_id="eni-attach-4b2050a7",
    #    delete_on_termination=true,
    #    device_index=0,
    #    instance_id="i-123",
    #    instance_owner_id="123",
    #    status="attached">,
    #  availability_zone="us-west-1b",
    #  description="Primary network interface",
    #  groups=[#<struct Aws::EC2::Types::GroupIdentifier group_name="default", group_id="sg-123">],
    #  interface_type="interface",
    #  ipv_6_addresses=[],
    #  mac_address="06:6f:22:85:59:74",
    #  network_interface_id="eni-123",
    #  owner_id="123",
    #  private_dns_name=nil,
    #  private_ip_address="172.30.0.181",
    #  private_ip_addresses=[#<struct Aws::EC2::Types::NetworkInterfacePrivateIpAddress association=nil, primary=true, private_dns_name=nil, private_ip_address="172.30.0.181">],
    #  requester_id=nil,
    #  requester_managed=false,
    #  source_dest_check=true,
    #  status="in-use",
    #  subnet_id="subnet-123",
    #  tag_set=[],
    #  vpc_id="vpc-123">
    @network_interface = network_interface
  end

  def facts
    [
      [:type_value, net_id = @network_interface.network_interface_id, Cwacop::AWS.NetworkInterface],
      [:link, net_id, @network_interface.subnet_id],
      [:link, net_id, @network_interface.vpc_id]
    ]
  end

end