require_relative '../resource'

class EC2 < Resource

  def initialize(instance)
    @instance = instance
  end

  def data
    @instance.data
  end

  def instance_id
    data.instance_id
  end

  def availability_zone
    data.placement.availability_zone
  end

  def image_id
    data.image_id
  end

  def key_name
    data.key_name
  end

  def subnet_id
    data.subnet_id
  end

  def vpc_id
    data.vpc_id
  end

  def block_device_mappings
    data.block_device_mappings
  end

  def network_interfaces
    data.network_interfaces
  end

  def security_groups
    data.security_groups
  end

  def state
    data.state
  end

  def facts
    [
      [:typed_value, type_name, instance_id = instance.instance_id],
      [:link, instance_id, :image, instance.image_id],
      [:link, instance_id, :key, instance.key_name],
      [:link, instance_id, :subnet, instance.subnet_id],
      [:link, instance_id, :vpc, instance.vpc_id],
      [:link, instance_id, :az, instance.availability_zone]
    ] + device_mapping_facts +
      network_interface_facts +
      security_group_facts +
      state_facts
  end

  ##
  # Generate facts for EBS volumes attached to an EC2 instance
  def device_mapping_facts
    device_mappings.map do |device_mapping|
      volume_id = device_mapping.ebs.volume_id
      [:link, instance_id, :volume, volume_id]
    end
  end
  
  ##
  # Generate facts for network interfaces associated with an EC2 instance
  def network_interface_facts
    network_interfaces.map do |interface|
      net_id = interface.network_interface_id
      [:link, instance_id, :network, net_id]
    end
  end
  
  ##
  # Generate facts for security groups associated with an EC2 instance
  def security_group_facts 
    security_groups.map do |group|
      [:link, instance_id, :group, group.group_id]
    end
  end
  
  ##
  # Grab the instance state so we know if it is stopped or running
  def state_facts
    [
      [:link, instance_id, :state, s]
    ]
  end

end