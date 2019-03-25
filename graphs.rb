require 'aws-sdk'
require 'fileutils'
require 'pry'
require_relative './lib/context'

context = Context.new
graph_prefix = "graph"
regions = ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2']

regions.each do |region|

  STDOUT.puts "Grabbing resources from #{region}."

  ec2_client = Aws::EC2::Resource.new(region: region)
  generic_client = Aws::EC2::Client.new(region: region)

  FileUtils.mkdir_p(graph_prefix)

  context.generate_resource_graphs!(graph_prefix, ec2_client, generic_client)
  
end