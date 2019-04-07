require 'aws-sdk'
require 'fileutils'

[
  'ec2', 'vpc', 'network_interface', 'subnet',
  'ami', 'key_pair', 'security_group', 'volume', 'snapshot',
  'iam'
].each { |l| require_relative "./aws/#{l}" }

##
# Holds the Prolog facts that will be eventually written to disk to
# be loaded and analyzed with swipl
class Context

  def initialize
    @context = []
  end

  ##
  # Write the current set of facts to disk.
  def persist_to_disk!(filename)
    File.open(filename, 'w') { |f| f.puts(@context.sort.uniq.join("\n")) }
  end

  ##
  # Grab the facts from the resource and add them to the context.
  def contextualize_resource!(resource, resource_value)
    resource.new(resource_value).contextualize_facts!(self)
  end

  ##
  # Dump all the possible facts for the given region specified by the given clients.
  def generate_resource_graphs!(prefix, region)
    ec2_client = Aws::EC2::Resource.new(region: region)
    generic_client = Aws::EC2::Client.new(region: region)
    iam = Aws::IAM::Client.new(region: region)
    owner_id = iam.get_user.user.arn.split(':')[-2]

    # Create the directory where we'll persist the resource graph
    region_dir = File.join(prefix, region)
    FileUtils.mkdir_p(region_dir)
    # We do this a lot below to save the graphs so better to factor out
    persistor = ->(resource) { persist_to_disk!(File.join(region_dir, "#{resource.name.downcase}.pl")) }

    {
      VPC => {
        client: generic_client,
        method_chain: [[:describe_vpcs], [:vpcs]]
      },
      NetworkInterface => {
        client: generic_client,
        method_chain: [[:describe_network_interfaces], [:network_interfaces]]
      },
      Subnet => {
        client: generic_client,
        method_chain: [[:describe_subnets], [:subnets]]
      },
      AMI => {
        client: generic_client,
        method_chain: [[:describe_images, {executable_users: ['self']}], [:images]]
      },
      KeyPair => {
        client: generic_client,
        method_chain: [[:describe_key_pairs], [:key_pairs]]
      },
      EC2 => {
        client: ec2_client,
        method_chain: [[:instances]]
      },
      SecurityGroup => {
        client: generic_client,
        method_chain: [[:describe_security_groups], [:security_groups]]
      },
      Volume => {
        client: generic_client,
        method_chain: [[:describe_volumes], [:volumes]]
      },
      Snapshot => {
        client: generic_client,
        method_chain: [[:describe_snapshots, {owner_ids: [owner_id]}], [:snapshots]]
      },
      IAM => {
        client: iam,
        method_chain: [[:get_account_authorization_details]]
      }
    }.each do |resource, parameters|
      remote_resource = parameters[:method_chain].reduce(parameters[:client]) do |v, m|
        begin
          v.send(*m)
        rescue StandardError => error
          binding.pry
        end
      end
      remote_resource.each do |v|
        contextualize_resource!(resource, v)
      end
      persistor[resource]
      reset!
    end

  end

  ##
  # Generate a fact of the form "type(val, typ)."
  def typed_value(typ, val)
    @context << "#{typ}(\"#{val}\")."
  end

  ##
  # Generate a fact that links two different values, e.g. "link(X, Y)."
  # "link(X, Y)." should be thought of as "X" _uses_ "Y".
  def link(source, attribute, *targets)
    joined_targets = targets.map { |t| quote(t) }.join(', ')
    @context << "link(\"#{source}\", #{attribute}, #{joined_targets})."
  end

  ##
  # Puts quotes around a value so that in the Prolog file we
  # get strings instead of some other data type.
  def quote(val)
    '"' + val + '"'
  end

  ##
  # Resets the context to an empty state. Useful when writing graphs
  # of multiple resource types to different files.
  def reset!
    @context = []
  end

end