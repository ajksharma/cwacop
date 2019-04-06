require_relative '../resource'

class Snapshot < Resource

  def initialize(snapshot)
    @snapshot = snapshot
    # => #<struct Aws::EC2::Types::Snapshot
    #    data_encryption_key_id=nil,
    #    description="Business/Industry Summary (Windows)",
    #    encrypted=false,
    #    kms_key_id=nil,
    #    owner_id="123",
    #    progress="100%",
    #    snapshot_id="snap-123",
    #    start_time=2008-11-19 12:15:17 UTC,
    #    state="completed",
    #    state_message=nil,
    #    volume_id="vol-123",
    #    volume_size=15,
    #    owner_alias="amazon",
    #    tags=[]>
  end

  def snapshot_id
    @snapshot.snapshot_id
  end

  def volume_id
    @snapshot.volume_id
  end

  def facts
    [
      [:typed_value, type_name, snapshot_id],
      [:link, snapshot_id, :volume, volume_id]
    ]
  end

end