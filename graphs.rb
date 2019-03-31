require 'pry'
require_relative './lib/context'

context = Context.new
graph_prefix = "graph"
regions = ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2']

regions.map do |region|
  # pid = fork do
    STDOUT.puts "Grabbing resources from #{region}."
    context.generate_resource_graphs!(graph_prefix, region) 
  # end
# end.each do |pid|
  # Process.waitpid(pid)
end
