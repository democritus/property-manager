module Admin::AgentsHelper
  
  include ::AgentsHelper
  
  # Set up blank fields for nested record
  def new_agent_setup(agent)
    returning(agent) do |a|
      a.agent_affiliations.build if a.agent_affiliations.empty?
    end
  end
end
