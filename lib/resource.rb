##
# Parent node for the various resource types.
class Resource

  ##
  # Mutates the context to fill in the facts for the given resource.
  def contextualize_facts!(context)
    facts.each do |fact|
      context.send(*fact)
    end
  end

end