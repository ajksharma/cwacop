[
  'ec2', 'vpc', 'network_interface', 'subnet',
  'ami', 'key_pair', 'security_group', 'volume'
].each { |l| require_relative "./#{l}" }

##
# Holds the Prolog facts that will be eventually written to disk to
# be loaded and analyzed with swipl
class Context

  def initialize
    @context = []
  end

  ##
  # Write the current set of facts to disk.
  def persist_to_disk(filename)
    File.open(filename, 'w') { |f| f.puts(@context.sort.uniq.join("\n")) }
  end

  ##
  # Grab the facts from the resource and add them to the context.
  def contextualize_resource!(resource, resource_value)
    resource.new(resource_value).contextualize_facts!(self)
  end

  ##
  # Dump all the possible facts for the given region specified by the given clients.
  def generate_resource_graphs!(prefix, ec2_client, generic_client)
    ##
    # Grab the VPCs
    generic_client.describe_vpcs.vpcs.each do |v|
      context.contextualize_resource!(VPC, v)
    end

    ##
    # Grab the network interface.
    generic_client.describe_network_interfaces.network_interfaces.each do |n|
      context.contextualize_resource!(NetworkInterface, n)
    end

    ##
    # Grab all the subnets.
    generic_client.describe_subnets.subnets.each do |s|
      context.contextualize_resource!(Subnet, s)
    end
  
    ##
    # Grab all the AMIs.
    generic_client.describe_images({executable_users: ['self']}).images.each do |i|
      context.contextualize_resource!(AMI, i)
    end

    ##
    # Grab all the SSH keys.
    generic_client.describe_key_pairs.key_pairs.each do |k|
      context.contextualize_resource!(KeyPair, k)
    end

    ##
    # Grab all the instances and link them with whatever other resources they're connected to.
    ec2_client.instances.each do |i|
      context.contextualize_resource!(EC2, i)
    end

    ##
    # Grab all the security groups so we can see which ones are being used.
    generic_client.describe_security_groups.security_groups.each do |sg|
      context.contextualize_resource!(SecurityGroup, sg)
    end

    ##
    # Grab the volumes.
    generic_client.describe_volumes.volumes.each do |v|
      context.contextualize_resource!(Volume, v)
    end

    ##
    # Grab the snapshots.
    generic_client.describe_snapshots.snapshots.each do |s|
      context.contextualize_resource!(Snapshot, s)
    end
  end

  ##
  # Generate a fact of the form "type(val, typ)."
  def typed_value(val, typ)
    @context << "type(\"#{val}\", #{typ})."
  end

  ##
  # Generate a fact that links two different values, e.g. "link(X, Y)."
  # "link(X, Y)." should be thought of as "X" _uses_ "Y".
  def link(source, target)
    @context << "link(\"#{source}\", \"#{target}\")."
  end

  ##
  # Resets the context to an empty state. Useful when writing graphs
  # of multiple resource types to different files.
  def reset!
    @context = []
  end

end