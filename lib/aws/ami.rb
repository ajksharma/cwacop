require_relative '../constants'
require_relative '../resource'

class AMI < Resource

  def initialize(image)
    # => #<struct Aws::EC2::Types::Image
    #  architecture="x86_64",
    #  creation_date="2016-05-10T18:50:00.000Z",
    #  image_id="ami-48c1f650",
    #  image_location="aws-marketplace/CentOS Linux 7 x86_64 HVM EBS 1704_01-b7ee8a69",
    #  image_type="machine",
    #  public=false,
    #  kernel_id=nil,
    #  owner_id="679593333241",
    #  platform=nil,
    #  product_codes=[#<struct Aws::EC2::Types::ProductCode product_code_id="abc", product_code_type="def">],
    #  ramdisk_id=nil,
    #  state="available",
    #  block_device_mappings=
    #   [#<struct Aws::EC2::Types::BlockDeviceMapping
    #     device_name="/dev/sda1",
    #     virtual_name=nil,
    #     ebs=
    #      #<struct Aws::EC2::Types::EbsBlockDevice
    #       delete_on_termination=false,
    #       iops=nil,
    #       snapshot_id="snap-123",
    #       volume_size=8,
    #       volume_type="standard",
    #       encrypted=false,
    #       kms_key_id=nil>,
    #     no_device=nil>],
    #  description="CentOS Linux 7 x86_64 HVM EBS",
    #  ena_support=false,
    #  hypervisor="xen",
    #  image_owner_alias="aws-marketplace",
    #  name="CentOS Linux 7 x86_64 HVM EBS 1704_01-b7ee8a69",
    #  root_device_name="/dev/sda1",
    #  root_device_type="ebs",
    #  sriov_net_support=nil,
    #  state_reason=nil,
    #  tags=[],
    #  virtualization_type="hvm">
    @image = image
  end

  def image_id
    @image.image_id
  end

  def image_type
    @image.image_type
  end

  def facts
    [
      [:typed_value, image_id, Cwacop::AWS::AMI],
      [:typed_value, image_type, Cwacop::AWS::AMIType],
      [:link, image_id, image_type]
    ] + block_device_facts
  end

  def block_device_facts
    @image.block_device_mappings.map do |device_mapping|
      unless device_mapping.ebs.nil?
        [:link, image_id, device_mapping.ebs.snapshot_id]
      end
    end.compact
  end

end