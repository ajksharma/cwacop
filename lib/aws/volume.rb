require_relative '../constants'
require_relative '../resource'

class Volume < Resource

  def initialize(volume)
    # => #<struct Aws::EC2::Types::Volume
    #  attachments=
    #   [#<struct Aws::EC2::Types::VolumeAttachment
    #     attach_time=2015-08-21 21:58:00 UTC,
    #     device="/dev/sda1",
    #     instance_id="i-123",
    #     state="attached",
    #     volume_id="vol-123",
    #     delete_on_termination=false>],
    #  availability_zone="us-west-2c",
    #  create_time=2015-08-21 21:51:57 UTC,
    #  encrypted=false,
    #  kms_key_id=nil,
    #  size=300,
    #  snapshot_id="snap-123",
    #  state="in-use",
    #  volume_id="vol-123",
    #  iops=900,
    #  tags=[#<struct Aws::EC2::Types::Tag key="Bill To", value="Engineering">],
    #  volume_type="gp2">
    @volume = volume
  end

  def volume_id
    @volume.volume_id
  end

  def snapshot_id
    @volume.snapshot_id
  end

  def facts
    [
      [:yped_value, volume_id, Cwacop::AWS.Volume],
      [:link, volum_id, snapshot_id]
    ] + attachment_facts
  end

  def attachment_facts
    @volume.attachments.map do |attachment|
      [:link, volume_id, attachment.instance_id]
    end
  end

end